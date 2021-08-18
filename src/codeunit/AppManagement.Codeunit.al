codeunit 50101 "App Management"
{
    trigger OnRun()
    begin

    end;

    var
        PSSession: Codeunit "PowerShell Runner";
        PSLogEntry: Record "Deployment Log";
        ProcessNameTxt: Text;
        AllFilesFilterTxt: Label '*.*';
        FileFilter: Label 'App (*.app)|*.app|All Files (*.*)|*.*';
        CancelledErr: Label 'Import cancelled';

    procedure GetNAVAppInfo()
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.Get(ServiceInstanceId(), SessionId());

        PSSession.OpenWindow;
        PSSession.UpdateWindow('Initializing');

        PSSession.ImportModule();

        PSSession.UpdateWindow('Fetching App Information');

        //Get Apps Information
        PSSession.AddCommand('Get-NAVAppInfo');
        PSSession.AddParameter('ServerInstance', ActiveSession."Server Instance Name");
        RunPS('Get App Information', 'Name');

    end;

    procedure ImportAppFileandDeploy(DatabaseInstance: Record "Database Instance")
    var
        FileMgt: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text[500];
    begin
        FileName := FileMgt.BLOBImportWithFilter(TempBlob, 'Select App File', '', FileFilter, AllFilesFilterTxt);

        if FileName = '' then begin
            Error(CancelledErr);
        end;

        FileName := TemporaryPath + FileName;

        if Exists(FileName) then begin
            Erase(FileName);
        end;

        FileMgt.BLOBExportToServerFile(TempBlob, FileName);

        PublishNAVApp(DatabaseInstance."Server Instance Name", FileName, true);
    end;

    procedure FindAppFileandDeploy(DatabaseInstance: Record "Database Instance"; Application: Record Application)
    var
        myInt: Integer;
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
    end;

    local procedure RunPS(Command: Text; Property: Text)
    var
        PSResults: DotNet PSObjectAdapter;
        ErrorMsg: Label ' Cmdlet failed to run, check event log'
        ;
    begin
        if PSSession.InitializePSRunner then
            while PSSession.NextResult(PSResults) do
                PSLogEntry.CreateInfoEntryWithDetails(Command, PSResults.GetProperty(Property))
        else
            PSLogEntry.CreateErrorEntry(Command + ErrorMsg);
    end;
}