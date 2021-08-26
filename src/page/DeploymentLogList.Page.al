page 50103 "Deployment Log List"
{
    Caption = 'PowerShell Logs';
    PageType = List;
    SourceTable = "PowerShell Log";
    UsageCategory = Lists;
    ApplicationArea = All;

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