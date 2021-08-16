page 50101 "Database Instance Card"
{
    Caption = 'Database Instance Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Database Instance";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Database Type"; "Database Type")
                {
                    ApplicationArea = All;
                }
                field("NST Server"; "NST Server")
                {
                    ApplicationArea = All;
                }
                field("Service Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                }
                field("Service Instance Path"; "Server Instance Path")
                {
                    ApplicationArea = All;
                }
                field("Database Server"; "Database Server")
                {
                    ApplicationArea = All;
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeployApps)
            {
                ApplicationArea = All;
                Caption = 'Deploy App';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myint: Integer;
}