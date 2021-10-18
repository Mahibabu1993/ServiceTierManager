/// <summary>
/// Page PowerShell Setup (ID 50105).
/// </summary>
page 50105 "PowerShell Setup"
{
    ApplicationArea = All;
    Caption = 'PowerShell Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "PowerShell Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(UserName; UserName)
                {
                    ApplicationArea = All;
                }
                field(Password; Password)
                {
                    ApplicationArea = All;
                }
                field("Use File Path for Deploment"; "Use File Path for Deploment")
                {
                    ApplicationArea = All;
                }
                field("Shared Folder Path"; "Shared Folder Path")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get() then begin
            Init;
            Insert;
        end;
    end;
}