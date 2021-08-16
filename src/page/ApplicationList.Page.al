page 50102 "Application List"
{
    ApplicationArea = All;
    Caption = 'Applications';
    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Application;
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
                field(Publisher; Publisher)
                {
                    ApplicationArea = All;
                }
                field("App Folder Location"; "App Folder Location")
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

        }
    }
}