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
            action(AddUser)
            {
                ApplicationArea = All;
                Caption = 'Add User';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Add User action';

                trigger OnAction()
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
                begin
                    ServiceTierManagement.SetPSModulePath(Rec."Server Instance Path" + 'NAVAdminTool.ps1');
                    ServiceTierManagement.AddUser("Server Instance Name");
                end;
            }
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
                    AppManagement.SetPSModulePath(Rec."Server Instance Path" + 'NAVAdminTool.ps1');
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
                    ServiceTierManagement.SetPSModulePath(Rec."Server Instance Path" + 'NAVAdminTool.ps1');
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
                    ServiceTierManagement.SetPSModulePath(Rec."Server Instance Path" + 'NAVAdminTool.ps1');
                    if not ServiceTierManagement.RestartServerInstance("Server Instance Name") then
                        Error(RestartErr, "Server Instance Name");
                end;
            }
            action(UpdateDatabaseDetails)
            {
                ApplicationArea = All;
                Caption = 'Update Database Details';
                Image = UpdateDescription;
                ToolTip = 'Executes the Update Database Details action';

                trigger OnAction()
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
                begin
                    ServiceTierManagement.UpdateDatabaseDetails(Rec);
                end;
            }
        }
    }
    var
        ImportFailedErr: Label 'License Import Failed';
        ImportSuccessMsg: Label 'License Import Successful';
        RestartErr: Label 'Server Instance %1 cannot be restarted';
}