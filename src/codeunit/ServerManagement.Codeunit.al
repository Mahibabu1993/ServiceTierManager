codeunit 50103 "Server Management"
{
    trigger OnRun()
    begin

    end;

    var
        PSSession: Codeunit "PowerShell Runner";

    procedure UpdateDatabaseInstanceList()
    var
        DatabaseInstance: Record "Database Instance";
        PSResults: DotNet PSObjectAdapter;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
        PSSession.UpdateWindow('Get Server Instances');

        PSSession.AddCommand('Get-NAVServerInstance');
        if PSSession.InitializePSRunner() then
            while PSSession.NextResult(PSResults) do begin
                DatabaseInstance.Init();
                DatabaseInstance."NST Server" := 'localhost';
                DatabaseInstance."Server Instance Name" := PSResults.GetProperty('ServerInstance');
                DatabaseInstance.Insert(true);
            end;

        PSSession.CloseWindow();
    end;
}