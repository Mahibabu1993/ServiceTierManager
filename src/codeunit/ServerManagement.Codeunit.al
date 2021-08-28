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
        ServerInstanceName: Text[130];
        ServerName: Text[100];
    begin
        ServerName := 'localhost';
        DatabaseInstance.SetRange("NST Server", ServerName);
        DatabaseInstance.DeleteAll();

        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
        PSSession.UpdateWindow('Get Server Instances');

        PSSession.AddCommand('Get-NAVServerInstance');
        if PSSession.InitializePSRunner() then
            while PSSession.NextResult(PSResults) do begin
                ServerInstanceName := PSResults.GetProperty('ServerInstance');
                DatabaseInstance.Init();
                DatabaseInstance."NST Server" := ServerName;
                DatabaseInstance."Server Instance Name" := CopyStr(ServerInstanceName, 28, StrLen(ServerInstanceName));
                DatabaseInstance.Insert(true);
            end;
        PSSession.CloseWindow();
    end;
}