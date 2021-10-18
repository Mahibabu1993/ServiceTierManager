/// <summary>
/// Codeunit Service Tier Management (ID 50103).
/// </summary>
codeunit 50103 "Service Tier Management"
{
    trigger OnRun()
    begin

    end;

    var
        PSSession: Codeunit "PowerShell Runner";
        AllFilesFilterTxt: Label '*.*';
        LicenseFileFilter: Label 'License (*.flf)|*.flf|All Files (*.*)|*.*';
        CancelledErr: Label 'Operation cancelled by user.';

    /// <summary>
    /// ImportLicense.
    /// </summary>
    /// <param name="ServerInstance">Text[100].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ImportLicense(ServerInstance: Text[100]): Boolean
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        PowerShellSetup: Record "PowerShell Setup";
        [InDataSet]
        DeleteFileonCompletion: Boolean;
        [InDataSet]
        Imported: Boolean;
        PSResults: DotNet PSObjectAdapter;
        FileName: Text[500];
    begin
        PowerShellSetup.Get();
        PowerShellSetup.TestField("Shared Folder Path");

        FileName := FileMgt.BLOBImportWithFilter(TempBlob, 'Select License File', '', LicenseFileFilter, AllFilesFilterTxt);

        if FileName = '' then
            Error(CancelledErr);

        FileName := PowerShellSetup."Shared Folder Path" + FileName;

        if Exists(FileName) then
            Erase(FileName);

        FileMgt.BLOBExportToServerFile(TempBlob, FileName);
        DeleteFileonCompletion := true;

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
        if DeleteFileonCompletion then
            if Exists(FileName) then
                Erase(FileName);
        exit(Imported);
    end;

    /// <summary>
    /// RestartServerInstance.
    /// </summary>
    /// <param name="ServerInstance">Text[100].</param>
    /// <returns>Return value of type Boolean.</returns>
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

    /// <summary>
    /// UpdateDatabaseDetails.
    /// </summary>
    /// <param name="DatabaseInstance">VAR Record "Database Instance".</param>
    procedure UpdateDatabaseDetails(var DatabaseInstance: Record "Database Instance")
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow(StrSubstNo('Updating Database Details for %1', DatabaseInstance."Server Instance Name"));
        DatabaseInstance."Database Server" := GetDatabaseServer(DatabaseInstance."Server Instance Name") + '\' + GetDatabaseInstance(DatabaseInstance."Server Instance Name");
        DatabaseInstance."Database Name" := GetDatabaseName(DatabaseInstance."Server Instance Name");
        DatabaseInstance."Web Client URL" := GetWebClientURL(DatabaseInstance."Server Instance Name");
        DatabaseInstance.Modify(true);
        PSSession.CloseWindow();
    end;

    /// <summary>
    /// UpdateDatabaseInstanceList.
    /// </summary>
    procedure UpdateDatabaseInstanceList()
    var
        DatabaseInstance: Record "Database Instance";
        PSResults: DotNet PSObjectAdapter;
        ServerName: Text[100];
        ServerInstanceName: Text[130];
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
                DatabaseInstance.State := PSResults.GetProperty('State');
                DatabaseInstance.Version := PSResults.GetProperty('Version');
                DatabaseInstance.Insert(true);
            end;
        PSSession.CloseWindow();

        if DatabaseInstance.FindSet() then
            repeat
                UpdateDatabaseDetails(DatabaseInstance);
            until DatabaseInstance.Next() = 0;
    end;

    local procedure GetDatabaseServer(ServerInstance: Text[100]): Text[100]
    var
        PSResults: DotNet PSObjectAdapter;
        PSResult: DotNet PSObject;
        DatabaseName: Text[100];
    begin
        PSSession.ImportModule();
        PSSession.AddCommand('Get-NAVServerConfiguration');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('KeyName', 'DatabaseServer');
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                PSResult := PSResults.PSObject();
                exit(PSResult.ToString());
            end;
    end;

    local procedure GetDatabaseInstance(ServerInstance: Text[100]): Text[100]
    var
        PSResults: DotNet PSObjectAdapter;
        PSResult: DotNet PSObject;
    begin
        PSSession.ImportModule();
        PSSession.AddCommand('Get-NAVServerConfiguration');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('KeyName', 'DatabaseInstance');
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                PSResult := PSResults.PSObject();
                exit(PSResult.ToString());
            end;
    end;

    local procedure GetDatabaseName(ServerInstance: Text[100]): Text[100]
    var
        PSResults: DotNet PSObjectAdapter;
        PSResult: DotNet PSObject;
        DatabaseName: Text[100];
    begin
        PSSession.ImportModule();
        PSSession.AddCommand('Get-NAVServerConfiguration');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('KeyName', 'DatabaseName');
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                PSResult := PSResults.PSObject();
                exit(PSResult.ToString());
            end;
    end;

    local procedure GetWebClientURL(ServerInstance: Text[100]): Text[500]
    var
        PSResults: DotNet PSObjectAdapter;
        PSResult: DotNet PSObject;
        DatabaseName: Text[100];
    begin
        PSSession.ImportModule();

        PSSession.AddCommand('Get-NAVServerConfiguration');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('KeyName', 'PublicWebBaseUrl');
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                PSResult := PSResults.PSObject();
                exit(PSResult.ToString());
            end;
    end;
}