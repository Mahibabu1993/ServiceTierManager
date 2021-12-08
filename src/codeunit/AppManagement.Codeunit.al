/// <summary>
/// Codeunit App Management (ID 50101).
/// </summary>
codeunit 50101 "App Management"
{
    trigger OnRun()
    begin

    end;

    var
        TempApplication: Record Application temporary;
        PSLogEntry: Record "PowerShell Log";
        PSSession: Codeunit "PowerShell Runner";
        PSModulePath: Text;
        SameVersionErr: Label 'Server %1 already contains the application with name %2 and version %3';

    /// <summary>
    /// ImportAppFileandDeploy.
    /// </summary>
    /// <param name="ServerInstance">Text[100].</param>
    procedure ImportAppFileandDeploy(ServerInstance: Text[100])
    var
        OldVersion: DotNet Version;
        Version: DotNet Version;
    begin
        TempApplication.Init();
        TempApplication.ServerInstance := ServerInstance;
        TempApplication."Powershell Module Path" := PSModulePath;
        TempApplication.Insert();
        if Page.RunModal(Page::"Deploy Application", TempApplication) = Action::Yes then begin
            if TempApplication."Existing Version" <> '' then begin
                Version := Version.Version(TempApplication.Version);
                OldVersion := OldVersion.Version(TempApplication."Existing Version");
                if Version.CompareTo(OldVersion) <= 0 then
                    Error(SameVersionErr, ServerInstance, TempApplication.Name, TempApplication."Existing Version");
            end;

            PublishNAVApp(ServerInstance, TempApplication."App File Path", TempApplication.SkipVerification);
            SyncNAVApp(ServerInstance, TempApplication.Name, TempApplication.Version, '');
            if TempApplication."Existing Version" <> '' then begin
                StartNAVAppDataUpgrade(ServerInstance, TempApplication.Name, TempApplication.Version);
                UnpublishNAVApp(ServerInstance, TempApplication.Name, TempApplication."Existing Version");
            end else
                InstallNAVApp(ServerInstance, TempApplication.Name, TempApplication.Version);
        end;
        if TempApplication."Delete File After Deployment" then
            if Exists(TempApplication."App File Path") then
                Erase(TempApplication."App File Path");
    end;

    /// <summary>
    /// ModifyTempApplication.
    /// </summary>
    /// <param name="ServerInstance">Text[100].</param>
    /// <param name="TempApplication">VAR Record Application.</param>
    procedure ModifyTempApplication(ServerInstance: Text[100]; var TempApplication: Record Application)
    var
        FilePath: Text[500];
        FileName: Text[500];
    begin
        FileName := TempApplication."App File Path";
        if FileName.Contains('\') then begin
            FilePath := CopyStr(FileName, 1, FileName.LastIndexOf('\'));
            FileName := CopyStr(FileName, FileName.LastIndexOf('\') + 1, StrLen(FileName));
        end;
        FindPublisherNameVersion(FileName, TempApplication.Publisher, TempApplication.Name, TempApplication.Version);
        FindOldVersion(ServerInstance, TempApplication.Name, TempApplication."Existing Version");
        TempApplication.Modify();
    end;

    /// <summary>
    /// SetPSModulePath.
    /// </summary>
    /// <param name="ModulePath">Text.</param>
    procedure SetPSModulePath(ModulePath: Text)
    begin
        PSModulePath := ModulePath;
    end;

    local procedure FindOldVersion(ServerInstance: Text[100]; var Name: Text[100]; var Version: Text[50])
    var
        PSResults: DotNet PSObjectAdapter;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Fetching App Information');

        //Get Apps Information
        PSSession.AddCommand('Get-NAVAppInfo');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        if Name = '' then
            RunPS('Get App Information', 'Name')
        else begin
            PSSession.AddParameter('Name', Name);
            if Version <> '' then
                PSSession.AddParameter('Version', Version);
            if PSSession.InitializePSRunner() then
                while PSSession.NextResult(PSResults) do begin
                    Name := PSResults.GetProperty('Name');
                    Version := PSResults.GetProperty('Version');
                end;
        end;
        PSSession.CloseWindow();
    end;

    local procedure FindPublisherNameVersion(FileName: Text[250]; var Publisher: Text[100]; var Name: Text[100]; var Version: Text[50])
    begin
        Publisher := CopyStr(FileName, 1, StrPos(FileName, '_') - 1);
        FileName := DelStr(FileName, 1, StrPos(FileName, '_'));
        Name := CopyStr(FileName, 1, StrPos(FileName, '_') - 1);
        FileName := DelStr(FileName, 1, StrPos(FileName, '_'));
        Version := CopyStr(FileName, 1, StrPos(FileName, '.app') - 1);
    end;

    local procedure InstallNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Install App');

        //Install App
        PSSession.AddCommand('Install-NAVApp');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('Name', AppName);
        if Version <> '' then
            PSSession.AddParameter('Version', Version);
        RunPS('Install-NAVApp', '');
        PSSession.CloseWindow();
    end;

    local procedure PublishNAVApp(ServerInstance: Text[100]; Path: Text[500]; SkipVerification: Boolean)
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Publishing App');

        //Publish Application
        PSSession.AddCommand('Publish-NAVApp');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('Path', Path);
        if SkipVerification then
            PSSession.AddParameterFlag('SkipVerification');
        RunPS('Publish-NAVApp', '');
        PSSession.CloseWindow();
    end;

    local procedure RunPS(Command: Text[500]; Property: Text)
    var
        PSResults: DotNet PSObjectAdapter;
        ErrorMsg: Label ' Cmdlet failed to run, check event log';
    begin
        if PSSession.InitializePSRunner() then
            while PSSession.NextResult(PSResults) do
                PSLogEntry.CreateInfoEntryWithDetails(Command, PSResults.GetProperty(Property))
        else
            PSLogEntry.CreateErrorEntry(Command + ErrorMsg);
    end;

    local procedure GetPSModulePath(): Text
    begin
        if Exists(PSModulePath) then
            exit(PSModulePath)
        else
            exit(ApplicationPath + 'NAVAdminTool.ps1');
    end;

    local procedure StartNAVAppDataUpgrade(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Start App Data Upgrade');

        //Start App Data Upgrade
        PSSession.AddCommand('Start-NAVAppDataUpgrade');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('Name', AppName);
        if Version <> '' then
            PSSession.AddParameter('Version', Version);
        RunPS('Start-NAVAppDataUpgrade', '');
        PSSession.CloseWindow();
    end;

    local procedure SyncNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50]; Mode: Text[20])
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Sync App');

        //Sync App
        PSSession.AddCommand('Sync-NAVApp');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('Name', AppName);
        if Version <> '' then
            PSSession.AddParameter('Version', Version);
        if Mode <> '' then
            PSSession.AddParameter('Mode', Mode);
        RunPS('Sync-NAVApp', '');
        PSSession.CloseWindow();
    end;

    local procedure UnpublishNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule(GetPSModulePath());
        PSSession.UpdateWindow('Unpublish App');

        //Unpublish App
        PSSession.AddCommand('Unpublish-NAVApp');
        PSSession.AddParameter('ServerInstance', ServerInstance);
        PSSession.AddParameter('Name', AppName);
        if Version <> '' then
            PSSession.AddParameter('Version', Version);
        RunPS('Unpublish-NAVApp', '');
        PSSession.CloseWindow();
    end;
}