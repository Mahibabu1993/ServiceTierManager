/// <summary>
/// Page Deploy Application (ID 50102).
/// </summary>
page 50102 "Deploy Application"
{
    Caption = 'Deploy Application';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = 'Upload And Deploy Extension';
    PageType = ConfirmationDialog;
    SourceTable = Application;

    layout
    {
        area(Content)
        {
            field("App File Path"; "App File Path")
            {
                ApplicationArea = All;
                Caption = 'Select .app file';
                ToolTip = 'Specifies the file path of the extension.';

                trigger OnAssistEdit()
                var
                    FileMgt: Codeunit "File Management";
                    TempBlob: Codeunit "Temp Blob";
                    PowerShellSetup: Record "PowerShell Setup";
                    FileName: Text[500];
                begin
                    FileName := FileMgt.BLOBImportWithFilter(TempBlob, 'Select App File', '', AppFileFilter, AllFilesFilterTxt);
                    if FileName = '' then
                        Error(CancelledErr);
                    if PowerShellSetup.Get() then begin
                        PowerShellSetup.TestField("Shared Folder Path");
                        FileName := PowerShellSetup."Shared Folder Path" + FileName;
                    end else
                        FileName := TemporaryPath + FileName;
                    if Exists(FileName) then
                        Erase(FileName);
                    FileMgt.BLOBExportToServerFile(TempBlob, FileName);
                    "Delete File After Deployment" := true;
                    Validate("App File Path", FileName);
                end;
            }
            field(Name; Name)
            {
                ApplicationArea = All;
                Caption = 'Name';
                ToolTip = 'Specifies the value of the Name field';
            }
            field(Version; Version)
            {
                ApplicationArea = All;
                Caption = 'Version';
                ToolTip = 'Specifies the value of the Version field';
            }
            field(SkipVerification; SkipVerification)
            {
                ApplicationArea = All;
                Caption = 'SkipVerification';
                ToolTip = 'Specifies the value of the SkipVerification field';
            }
            field("Delete File After Deployment"; "Delete File After Deployment")
            {
                ApplicationArea = All;
                Caption = 'Delete File After Deployment';
                ToolTip = 'Specifies the value of the Delete File After Deployment field';
            }
            field("Existing Version"; "Existing Version")
            {
                ApplicationArea = All;
                Caption = 'Existing Version';
                ToolTip = 'Specifies the value of the Existing Version field';
            }
        }
    }
    var
        AllFilesFilterTxt: Label '*.*';
        AppFileFilter: Label 'App (*.app)|*.app|All Files (*.*)|*.*';
        CancelledErr: Label 'Import cancelled';
}