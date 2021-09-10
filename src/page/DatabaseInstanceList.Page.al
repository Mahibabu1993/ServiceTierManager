/// <summary>
/// Page Database Instance List (ID 50100).
/// </summary>
page 50100 "Database Instance List"
{
    ApplicationArea = All;
    Caption = 'Database Instances';
    CardPageId = "Database Instance Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Database Instance";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
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
                field("Server Instance Path"; "Server Instance Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance Path field';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh Database Instances';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Refresh;
                ToolTip = 'Executes the Refresh Database Instances action';

                trigger OnAction();
                var
                    ServiceTierManagement: Codeunit "Service Tier Management";
                begin
                    ServiceTierManagement.UpdateDatabaseInstanceList();
                    CurrPage.Update();
                end;
            }
        }
    }
}