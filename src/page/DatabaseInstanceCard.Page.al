/// <summary>
/// Page Database Instance Card (ID 50101).
/// </summary>
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
                    ToolTip = 'Specifies the value of the NST Server field';
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance Name field';
                }
                field(State; State)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the State';
                }
                field(Version; Version)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version';
                }
                field("Server Instance Path"; "Server Instance Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance Path field';
                }
                field("Database Server"; "Database Server")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Database Server field';
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Database Name field';
                }
                field("Web Client URL"; "Web Client URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Web Client URL field';
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
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Deploy App action';

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
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Import License action';

                trigger OnAction()
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
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
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Restart Server Instance action';

                trigger OnAction()
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
                begin
                    if not ServiceTierManagement.RestartServerInstance("Server Instance Name") then
                        Error(RestartErr, "Server Instance Name");
                end;
            }
        }
    }
    var
        ImportFailedErr: Label 'License Import Failed';
        ImportSuccessMsg: Label 'License Import Successful';
        RestartErr: Label 'Server Instance %1 cannot be restarted';
}