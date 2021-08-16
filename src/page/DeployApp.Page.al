page 50103 "Deploy App"
{
    Caption = 'Deploy App';
    DelayedInsert = true;
    PageType = NavigatePage;
    SourceTable = "Deployment Log";

    layout
    {
        area(Content)
        {
            group(Control1)
            {
                field("App Name"; "App Name")
                {
                    ApplicationArea = All;
                }
                field("App Publisher"; "App Publisher")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}