page 50104 "PS Results"
{
    PageType = CardPart;
    SourceTable = "PowerShell Log";

    layout
    {
        area(content)
        {
            field(GetDetailsText; GetDetailsText())
            {
                ApplicationArea = All;
                MultiLine = true;
                Width = 50;
                ToolTip = 'Specifies the value of the GetDetailsText() field';
            }
        }
    }

    actions
    {
    }
}

