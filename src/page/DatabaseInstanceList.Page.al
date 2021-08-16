page 50100 "Database Instance List"
{
    ApplicationArea = All;
    Caption = 'Database Instances';
    Editable = false;
    PageType = List;
    CardPageId = "Database Instance Card";
    RefreshOnActivate = true;
    SourceTable = "Database Instance";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Name; Name)
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
                field("Database Type"; "Database Type")
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
                field("Service Instance Path"; "Server Instance Path")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}