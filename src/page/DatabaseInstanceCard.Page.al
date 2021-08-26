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
            action(DeployApp)
            {
                ApplicationArea = All;
                Caption = 'Deploy App';

                trigger OnAction()
                var
                    AppManagement: Codeunit "App Management";
                begin
                    SelectAppandDeploy();
                end;
            }
        }
    }

    var
        myint: Integer;
}