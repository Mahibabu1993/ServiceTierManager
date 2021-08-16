page 50104 "Deployment Log List"
{
    Caption = 'Deployment Logs';
    PageType = List;
    SourceTable = "Deployment Log";
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

                field("App Publisher"; "App Publisher")
                {
                    ApplicationArea = All;
                    Caption = 'App Publisher';
                    Tooltip = 'Specifies the App Publisher.';
                }

                field("App Name"; "App Name")
                {
                    ApplicationArea = All;
                    Caption = 'App Name';
                    Tooltip = 'Specifies the App Name.';
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

                field("NST Server"; "NST Server")
                {
                    ApplicationArea = All;
                    Caption = 'NST Server';
                    Tooltip = 'Specifies the NST Server.';
                }

                field("Service Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                    Caption = 'Service Instance Name';
                    ToolTip = 'Specifies the Service Instance Name';
                }

                field("Database Server"; "Database Server")

                {
                    ApplicationArea = All;
                    Caption = 'Database Server';
                    Tooltip = 'Specifies the Database Server.';
                }

                field("Database Name"; "Database Name")
                {
                    ApplicationArea = All;
                    Caption = 'Database Name';
                    Tooltip = 'Specifies the Database Name.';
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