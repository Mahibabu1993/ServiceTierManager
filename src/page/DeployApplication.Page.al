page 50102 "Deploy Application"
{
    Caption = 'Deploy Application';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = '';
    SourceTable = Application;
    PageType = ConfirmationDialog;

    layout
    {
        area(Content)
        {
            field(Name; Name)
            {
                ApplicationArea = All;
                Caption = 'Name';
            }
            field(Version; Version)
            {
                ApplicationArea = All;
                Caption = 'Version';
            }
            field(SkipVerification; SkipVerification)
            {
                ApplicationArea = All;
                Caption = 'SkipVerification';
            }
            field("Existing Version"; "Existing Version")
            {
                ApplicationArea = All;
                Caption = 'Existing Version';
            }
            field("App File Path"; "App File Path")
            {
                ApplicationArea = All;
                Caption = 'App File Path';
            }
        }
    }
}