codeunit 50101 "App Management"
{
    trigger OnRun()
    begin

    end;

    var
        PSSession: Codeunit "PowerShell Runner";
        PSLogEntry: Record "PowerShell Log";
        Application: Record Application temporary;
        ProcessNameTxt: Text;
        AllFilesFilterTxt: Label '*.*';
        FileFilter: Label 'App (*.app)|*.app|All Files (*.*)|*.*';
        CancelledErr: Label 'Import cancelled';
        SameVersionErr: Label 'Server %1 already contains the application with name %2 and version %3';

    local procedure FindPublisherNameVersion(FileName: Text[250]; var Publisher: Text[100]; var Name: Text[100]; var Version: Text[50])
    var
        myInt: Integer;
    begin
        Publisher := CopyStr(FileName, 1, StrPos(FileName, '_') - 1);
        FileName := DelStr(FileName, 1, StrPos(FileName, '_'));
        Name := CopyStr(FileName, 1, StrPos(FileName, '_') - 1);
        FileName := DelStr(FileName, 1, StrPos(FileName, '_'));
        Version := CopyStr(FileName, 1, StrPos(FileName, '.app') - 1);
    end;

    procedure FindOldVersion(ServerInstance: Text[100]; var Name: Text[100]; var Version: Text[50])
    var
        PSResults: DotNet PSObjectAdapter;
    begin
        PSSession.OpenWindow;
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
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

    local procedure InsertApplicationDetails(Publisher: Text[100]; Name: Text[100]; Version: Text[100]; OldVersion: Text[100]; FileName: Text[500])
    var
        myInt: Integer;
    begin
        Application.Init();
        Application.Publisher := Publisher;
        Application.Name := Name;
        Application.Version := Version;
        Application."Existing Version" := OldVersion;
        Application."App File Path" := FileName;
        Application.Insert();
    end;

    procedure ImportAppFileandDeploy(ServerInstance: Text[100])
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text[500];
        Publisher: Text[100];
        Name: Text[100];
        Version: Text[50];
        OldVersion: Text[50];
        PSResults: DotNet PSObjectAdapter;
    begin
        FileName := FileMgt.BLOBImportWithFilter(TempBlob, 'Select App File', '', FileFilter, AllFilesFilterTxt);

        if FileName = '' then begin
            Error(CancelledErr);
        end;

        FindPublisherNameVersion(FileName, Publisher, Name, Version);
        FindOldVersion(ServerInstance, Name, OldVersion);
        FileName := TemporaryPath + FileName;
        InsertApplicationDetails(Publisher, Name, Version, OldVersion, FileName);
        if Page.RunModal(Page::"Deploy Application", Application) = Action::Yes then begin
            if Application.Version = Application."Existing Version" then
                Error(SameVersionErr, ServerInstance, Application.Name, Application.Version);
            if Exists(Application."App File Path") then begin
                Erase(Application."App File Path");
            end;

            FileMgt.BLOBExportToServerFile(TempBlob, Application."App File Path");

            PublishNAVApp(ServerInstance, Application."App File Path", Application.SkipVerification);
            SyncNAVApp(ServerInstance, Application.Name, Application.Version, '');
            if Application."Existing Version" <> '' then begin
                StartNAVAppDataUpgrade(ServerInstance, Application.Name, Application.Version);
                UnpublishNAVApp(ServerInstance, Application.Name, Application."Existing Version");
            end else
                InstallNAVApp(ServerInstance, Application.Name, Application.Version);
        end;
    end;

    procedure FindAppFileandDeploy(DatabaseInstance: Record "Database Instance"; Application: Record Application)
    var
        myint: Integer;
    begin

    end;

    local procedure PublishNAVApp(ServerInstance: Text[100]; Path: Text[500]; SkipVerification: Boolean)
    var
        myInt: Integer;
    begin
        PSSession.OpenWindow;
        PSSession.UpdateWindow('Initializing');

        PSSession.ImportModule();

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

    local procedure SyncNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50]; Mode: Text[20])
    var
        myInt: Integer;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
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

    local procedure StartNAVAppDataUpgrade(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    var
        myInt: Integer;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
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

    local procedure InstallNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    var
        myInt: Integer;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
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

    local procedure UnpublishNAVApp(ServerInstance: Text[100]; AppName: Text[100]; Version: Text[50])
    var
        myInt: Integer;
    begin
        PSSession.OpenWindow();
        PSSession.UpdateWindow('Initializing');
        PSSession.ImportModule();
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

    local procedure RunPS(Command: Text; Property: Text)
    var
        PSResults: DotNet PSObjectAdapter;
        ErrorMsg: Label ' Cmdlet failed to run, check event log';
    begin
        if PSSession.InitializePSRunner then
            while PSSession.NextResult(PSResults) do
                PSLogEntry.CreateInfoEntryWithDetails(Command, PSResults.GetProperty(Property))
        else
            PSLogEntry.CreateErrorEntry(Command + ErrorMsg);
    end;
}