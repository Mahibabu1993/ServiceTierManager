/// <summary>
/// Page PS Results (ID 50104).
/// </summary>
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
                ToolTip = 'Specifies the value of the GetDetailsText() field';
                Width = 50;
            }
        }
    }
}

