codeunit 50103 "Service Tier Management"
{
    trigger OnRun()
    begin

    end;

    var
        PSSession: Codeunit "PowerShell Runner";
        Txt001: Label 'Operation cancelled by user.';
        AllFilesFilterTxt: Label '*.*';
        FileFilter: Label 'License (*.flf)|*.flf|All Files (*.*)|*.*';

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

    procedure ImportLicense(ServerInstance: Text[100]): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        FileName: Text[500];
        [InDataSet]
        Imported: Boolean;
        PSResults: DotNet PSObjectAdapter;
    begin
        FileName := FileMgt.BLOBImportWithFilter(TempBlob, 'Select License File', '', FileFilter, AllFilesFilterTxt);

        if FileName = '' then begin
            Error(Txt001);
        end;

        FileName := TemporaryPath + FileName;

        if Exists(FileName) then begin
            Erase(FileName);
        end;

        FileMgt.BLOBExportToServerFile(TempBlob, FileName);

        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
        PSSession.UpdateWindow('Import License');

        PSSession.AddCommand('Import-NAVServerLicense');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('LicenseFile', FileName);
        if PSSession.InitializePSRunner() then
            Imported := PSSession.NextResult(PSResults);
        PSSession.CloseWindow();
        exit(Imported);
    end;

    procedure RestartServerInstance(ServerInstance: Text[100]): Boolean
    var
        ActiveSession: Record "Active Session";
        Restarted: Boolean;
        PSResults: DotNet PSObjectAdapter;
    begin
        ActiveSession.Get(ServiceInstanceId(), SessionId());
        if ActiveSession."Server Instance Name" = ServerInstance then
            exit(false);

        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
        PSSession.UpdateWindow(StrSubstNo('Restart Server Instance %1', ServerInstance));

        PSSession.AddCommand('Restart-NAVServerInstance');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        if PSSession.InitializePSRunner() then
            Restarted := PSSession.NextResult(PSResults);
        PSSession.CloseWindow();
        exit(Restarted);
    end;
}