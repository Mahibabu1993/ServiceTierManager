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
        PSModulePath: Text;
        AllFilesFilterTxt: Label '*.*';
        LicenseFileFilter: Label 'License (*.flf)|*.flf|All Files (*.*)|*.*';
        CancelledErr: Label 'Operation cancelled by user.';

    /// <summary>
    /// AddUser.
    /// </summary>
    /// <param name="ServerInstance">Text[100].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AddUser(ServerInstance: Text[100]): Boolean
    var
        UserAdded: Boolean;
        PSResults: DotNet PSObjectAdapter;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow(StrSubstNo('Adding user %1 to %2', UserId, ServerInstance));

        PSSession.AddCommand('New-NAVServerUser');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('WindowsAccount', UserId);
        if PSSession.InitializePSRunner() then
            UserAdded := PSSession.NextResult(PSResults);

        PSSession.AddCommand('New-NAVServerUser');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('WindowsAccount', UserId);
        PSSession.AddParameter('PermissionSetID', 'SUPER');
        if PSSession.InitializePSRunner() then
            UserAdded := PSSession.NextResult(PSResults);
        PSSession.CloseWindow();
        exit(UserAdded);
    end;

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
        PSSession.ImportModule(GetPSModulePath());
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
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow(StrSubstNo('Restart Server Instance %1', ServerInstance));

        PSSession.AddCommand('Restart-NAVServerInstance');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        if PSSession.InitializePSRunner() then
            Restarted := PSSession.NextResult(PSResults);
        PSSession.CloseWindow();
        exit(Restarted);
    end;

    /// <summary>
    /// SetPSModulePath.
    /// </summary>
    /// <param name="ModulePath">Text.</param>
    procedure SetPSModulePath(ModulePath: Text)
    begin
        PSModulePath := ModulePath;
    end;

    /// <summary>
    /// UpdateDatabaseDetails.
    /// </summary>
    /// <param name="DatabaseInstance">VAR Record "Database Instance".</param>
    procedure UpdateDatabaseDetails(var DatabaseInstance: Record "Database Instance")
    var
        DatabaseInstanceName: Text[100];
    begin
        DatabaseInstance."Server Instance Path" := GetServerInstancePath(DatabaseInstance."Server Instance Name");
        SetPSModulePath(DatabaseInstance."Server Instance Path" + 'NAVAdminTool.ps1');
        Clear(PSSession);
        PSSession.OpenWindow();
        PSSession.UpdateWindow(StrSubstNo('Updating Database Details for %1', DatabaseInstance."Server Instance Name"));
        DatabaseInstance."Database Server" := GetDatabaseServer(DatabaseInstance."Server Instance Name");
        DatabaseInstanceName := GetDatabaseInstance(DatabaseInstance."Server Instance Name");
        if DatabaseInstanceName <> '' then
            DatabaseInstance."Database Server" := DatabaseInstance."Database Server" + '\' + DatabaseInstanceName;
        DatabaseInstance."Database Name" := GetDatabaseName(DatabaseInstance."Server Instance Name");
        DatabaseInstance."Web Client URL" := GetWebClientURL(DatabaseInstance."Server Instance Name");
        DatabaseInstance.Modify(true);
        PSSession.CloseWindow();
    end;

    /// <summary>
    /// UpdateDatabaseInstanceList.
    /// </summary>
    /// <param name="ServerName">Text[100].</param>
    procedure UpdateDatabaseInstanceList(ServerName: Text[100])
    var
        DatabaseInstance: Record "Database Instance";
        PSResults: DotNet PSObjectAdapter;
        ServerInstanceName: Text[130];
    begin
        if ServerName = '' then
            exit;
        DatabaseInstance.SetRange("NST Server", ServerName);
        if DatabaseInstance.FindSet() then
            DatabaseInstance.DeleteAll();

        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow(StrSubstNo('Get Server Instances from %1', ServerName));

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
        PSSession.ImportModule(GetPSModulePath());
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
        PSSession.ImportModule(GetPSModulePath());
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
        PSSession.ImportModule(GetPSModulePath());
        PSSession.AddCommand('Get-NAVServerConfiguration');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('KeyName', 'DatabaseName');
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                PSResult := PSResults.PSObject();
                exit(PSResult.ToString());
            end;
    end;

    local procedure GetPSModulePath(): Text
    begin
        if Exists(PSModulePath) then
            exit(PSModulePath)
        else
            exit(ApplicationPath + 'NAVAdminTool.ps1');
    end;

    local procedure GetServerInstancePath(ServerInstance: Text[100]): Text[500]
    var
        ServerInstancePath: Text;
        PSResults: DotNet PSObjectAdapter;
    begin
        PSSession.AddCommand('Get-WmiObject');
        PSSession.AddParameter('Query', StrSubstNo('select PathName from win32_service where Name = "MicrosoftDynamicsNAVServer$%1"', ServerInstance));
        if PSSession.InitializePSRunner() then
            if PSSession.NextResult(PSResults) then begin
                ServerInstancePath := PSResults.GetProperty('PathName');
            end;
        if ServerInstancePath = '' then
            exit('');
        ServerInstancePath := CopyStr(ServerInstancePath, 2, ServerInstancePath.IndexOf('Microsoft.Dynamics.Nav.Server.exe') - 2);
        exit(ServerInstancePath);
    end;

    local procedure GetWebClientURL(ServerInstance: Text[100]): Text[500]
    var
        PSResults: DotNet PSObjectAdapter;
        PSResult: DotNet PSObject;
        DatabaseName: Text[100];
    begin
        PSSession.ImportModule(GetPSModulePath());
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