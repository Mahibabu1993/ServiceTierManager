/// <summary>
/// Codeunit PowerShell Runner (ID 50100).
/// </summary>
codeunit 50100 "PowerShell Runner"
{

    trigger OnRun()
    begin
    end;

    var
        PSRunner: DotNet PowerShellRunner;
        ResultsEnumerator: DotNet IEnumerator;
        [InDataSet]
        Created: Boolean;
        ErrorEnumerator: DotNet IEnumerator_Of_T;
        Window: Dialog;

    /// <summary>
    /// AddCommand.
    /// </summary>
    /// <param name="Command">Text.</param>
    [Scope('OnPrem')]
    procedure AddCommand(Command: Text)
    begin
        CreatePSRunner();
        PSRunner.AddCommand(Command);
    end;

    /// <summary>
    /// AddParameter.
    /// </summary>
    /// <param name="Name">Text.</param>
    /// <param name="Value">Variant.</param>
    [Scope('OnPrem')]
    procedure AddParameter(Name: Text; Value: Variant)
    begin
        CreatePSRunner();
        PSRunner.AddParameter(Name, Value);
    end;

    /// <summary>
    /// AddParameterFlag.
    /// </summary>
    /// <param name="Name">Text.</param>
    [Scope('OnPrem')]
    procedure AddParameterFlag(Name: Text)
    begin
        CreatePSRunner();
        PSRunner.AddParameter(Name);
    end;

    /// <summary>
    /// CloseWindow.
    /// </summary>
    [Scope('OnPrem')]
    procedure CloseWindow()
    begin
        Window.Close();
    end;

    /// <summary>
    /// ImportModule.
    /// </summary>
    /// <param name="PSModule">Text.</param>
    [Scope('OnPrem')]
    procedure ImportModule(PSModule: Text)
    begin
        CreatePSRunner();
        PSRunner.ImportModule(PSModule);
    end;

    /// <summary>
    /// InitializePSRunner.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    [Scope('OnPrem')]
    procedure InitializePSRunner(): Boolean
    begin
        //Initialize ps session
        CreatePSRunner();

        if not Invoke() then
            exit(not PSRunnerHadErrors());

        GetResultEnumerator(ResultsEnumerator);
        GetErrorEnumerator(ErrorEnumerator);

        exit(not PSRunnerHadErrors());
    end;

    /// <summary>
    /// Invoke.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    [Scope('OnPrem')]
    procedure Invoke(): Boolean
    begin
        PSRunner.BeginInvoke();
        repeat
            Sleep(2000);
        //(to be resilient against SQL connection drops)
        until PSRunner.IsCompleted;
        exit(not PSRunnerHadErrors());
    end;

    /// <summary>
    /// NextResult.
    /// </summary>
    /// <param name="ReturnObject">VAR DotNet PSObjectAdapter.</param>
    /// <returns>Return value of type Boolean.</returns>
    [Scope('OnPrem')]
    procedure NextResult(var ReturnObject: DotNet PSObjectAdapter): Boolean
    begin
        if IsNull(ResultsEnumerator) then
            exit(false);

        if ResultsEnumerator.MoveNext() then begin
            ReturnObject := ReturnObject.PSObjectAdapter();
            ReturnObject.PSObject := ResultsEnumerator.Current;
            exit(true)
        end;
        exit(false)
    end;

    /// <summary>
    /// OpenWindow.
    /// </summary>
    [Scope('OnPrem')]
    procedure OpenWindow()
    begin
        Window.Open(
          'Running Powershell                \' +
          'Status #1##################################');
    end;

    /// <summary>
    /// UpdateWindow.
    /// </summary>
    /// <param name="Status">Text.</param>
    [Scope('OnPrem')]
    procedure UpdateWindow(Status: Text)
    begin
        Window.Update(1, Status);
    end;

    local procedure CreatePSRunner(): Boolean
    begin
        if Created then
            exit(Created);
        if not IsNull(PSRunner) then
            exit(false);

        PSRunner := PSRunner.CreateInSandbox();
        PSRunner.WriteEventOnError := true;

        Created := true;
        exit(Created);
    end;

    local procedure GetErrorEnumerator(Enumerator: DotNet IEnumerator)
    begin
        Enumerator := PSRunner.Errors.GetEnumerator();
    end;

    local procedure GetResultEnumerator(Enumerator: DotNet IEnumerator)
    begin
        Enumerator := PSRunner.Results.GetEnumerator();
    end;

    local procedure PSRunnerHadErrors(): Boolean
    begin
        if PSRunner.HadErrors then
            PSRunner.WriteEventOnError(true);
        exit(PSRunner.HadErrors);
    end;
}