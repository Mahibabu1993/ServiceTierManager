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
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Process;

                trigger OnAction()
                var
                    AppManagement: Codeunit "App Management";
                begin
                    AppManagement.ImportAppFileandDeploy("Server Instance Name");
                end;
            }
            action(ImportLicense)
            {
                ApplicationArea = All;
                Caption = 'Import License';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction()
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
                begin
                    ServiceTierManagement.ImportLicense("Server Instance Name");
                end;
            }
        }
    }
}