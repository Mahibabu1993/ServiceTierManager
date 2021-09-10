/// <summary>
/// Page Deploy Application (ID 50102).
/// </summary>
page 50102 "Deploy Application"
{
    Caption = 'Deploy Application';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = 'Please verify the below details and correct if required';
    PageType = ConfirmationDialog;
    SourceTable = Application;

    layout
    {
        area(Content)
        {
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
            field("Existing Version"; "Existing Version")
            {
                ApplicationArea = All;
                Caption = 'Existing Version';
                ToolTip = 'Specifies the value of the Existing Version field';
            }
            field("App File Path"; "App File Path")
            {
                ApplicationArea = All;
                Caption = 'App File Path';
                ToolTip = 'Specifies the value of the App File Path field';
            }
        }
    }
}