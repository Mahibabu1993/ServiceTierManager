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
        MgmtModule: Label 'NAVAdminTool.ps1';
        Window: Dialog;

    [Scope('OnPrem')]
    procedure InitializePSRunner(): Boolean
    begin
        //Initialize ps session
        CreatePSRunner;

        if not Invoke then
            exit(not PSRunnerHadErrors);

        GetResultEnumerator(ResultsEnumerator);
        GetErrorEnumerator(ErrorEnumerator);

        exit(not PSRunnerHadErrors);
    end;

    local procedure CreatePSRunner(): Boolean
    begin
        if Created then
            exit(Created);
        if not IsNull(PSRunner) then
            exit(false);

        PSRunner := PSRunner.CreateInSandbox;
        PSRunner.WriteEventOnError := true;

        Created := true;
        exit(Created);
    end;

    [Scope('OnPrem')]
    procedure AddCommand(Command: Text)
    begin
        CreatePSRunner;
        PSRunner.AddCommand(Command);
    end;

    [Scope('OnPrem')]
    procedure AddParameter(Name: Text; Value: Variant)
    begin
        CreatePSRunner;
        PSRunner.AddParameter(Name, Value);
    end;

    [Scope('OnPrem')]
    procedure AddParameterFlag(Name: Text)
    begin
        CreatePSRunner;
        PSRunner.AddParameter(Name);
    end;

    [Scope('OnPrem')]
    procedure Invoke(): Boolean
    begin
        PSRunner.BeginInvoke;
        repeat
            Sleep(2000);
        //(to be resilient against SQL connection drops)
        until PSRunner.IsCompleted;
        exit(not PSRunnerHadErrors);
    end;

    local procedure GetResultEnumerator(Enumerator: DotNet IEnumerator)
    begin
        Enumerator := PSRunner.Results.GetEnumerator;
    end;

    [Scope('OnPrem')]
    procedure NextResult(var ReturnObject: DotNet PSObjectAdapter): Boolean
    begin
        if IsNull(ResultsEnumerator) then
            exit(false);

        if ResultsEnumerator.MoveNext then begin
            ReturnObject := ReturnObject.PSObjectAdapter;
            ReturnObject.PSObject := ResultsEnumerator.Current;
            exit(true)
        end;
        exit(false)
    end;

    [Scope('OnPrem')]
    procedure ImportModule()
    begin
        CreatePSRunner;
        PSRunner.ImportModule(PSModules);
    end;

    local procedure GetErrorEnumerator(Enumerator: DotNet IEnumerator)
    begin
        Enumerator := PSRunner.Errors.GetEnumerator;
    end;

    [Scope('OnPrem')]
    procedure PSModules(): Text
    begin
        exit(ApplicationPath + MgmtModule);
    end;

    local procedure PSRunnerHadErrors(): Boolean
    begin
        if PSRunner.HadErrors then
            PSRunner.WriteEventOnError(true);
        exit(PSRunner.HadErrors);
    end;

    [Scope('OnPrem')]
    procedure OpenWindow()
    begin
        Window.Open(
          'Running Powershell                \' +
          'Status #1##################################');
    end;

    [Scope('OnPrem')]
    procedure UpdateWindow(Status: Text)
    begin
        Window.Update(1, Status);
    end;

    [Scope('OnPrem')]
    procedure CloseWindow()
    begin
        Window.Close;
    end;

    [Scope('OnPrem')]
    procedure AddPowerShellCommands(Command: Text[100]; ParamName: array[10] of Text[100]; ParamText: array[10] of text[100]; ParamFlag: array[10] of Text[100])
    var
        noOfParameters: Integer;
        noOfParameterFlags: Integer;
        Counter: Integer;
    begin
        ImportModule();
        AddCommand(Command);

        Counter := 1;
        if ParamName[Counter] <> '' then
            repeat
                AddParameter(ParamName[Counter], ParamText[Counter]);
                Counter += 1;
            until ParamName[Counter] = '';

        Counter := 1;
        if ParamName[Counter] <> '' then
            repeat
                AddParameterFlag(ParamFlag[Counter]);
                Counter += 1;
            until ParamFlag[Counter] = '';
    end;
}

