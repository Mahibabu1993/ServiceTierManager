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
                begin
                    if ServiceTierManagement.ImportLicense("Server Instance Name") then
                        Message(ImportSuccessMsg)
                    else
                        Error(ImportFailedErr);
                end;
            }
            action(RestartServerInstance)
            {
                ApplicationArea = All;
                Caption = 'Restart Server Instance';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ResetStatus;

                trigger OnAction()
                begin
                    if not ServiceTierManagement.RestartServerInstance("Server Instance Name") then
                        Error(RestartErr, "Server Instance Name");
                end;
            }
        }
    }
    var
        AppManagement: Codeunit "App Management";
        ServiceTierManagement: Codeunit "Service Tier Management";
        ImportSuccessMsg: Label 'License Import Successful';
        ImportFailedErr: Label 'License Import Failed';
        RestartErr: Label 'Server Instance %1 cannot be restarted';
}