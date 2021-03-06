/// <summary>
/// Page PowerShell Log List (ID 50103).
/// </summary>
page 50103 "PowerShell Log List"
{
    ApplicationArea = All;
    Caption = 'PowerShell Logs';
    PageType = List;
    SourceTable = "PowerShell Log";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("ID"; "ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Tooltip = 'Specifies the ID.';
                }
                field("Type"; "Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Tooltip = 'Specifies the Type.';
                }
                field("PowerShell Command"; "PowerShell Command")
                {
                    ApplicationArea = All;
                    Caption = 'PowerShell Command';
                    ToolTip = 'Specifies the PowerShell Command.';
                }
                field("Date"; "Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    Tooltip = 'Specifies the Date.';
                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                    Caption = 'User Name';
                    Tooltip = 'Specifies the User Name.';
                }
            }
        }

        area(FactBoxes)
        {
            part("Show Details"; "PS Results")
            {
                ApplicationArea = All;
                SubPageLink = ID = FIELD(ID);
                UpdatePropagation = Both;
            }
        }
    }
}