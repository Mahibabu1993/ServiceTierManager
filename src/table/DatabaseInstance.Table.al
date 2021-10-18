/// <summary>
/// Table Database Instance (ID 50100).
/// </summary>
table 50100 "Database Instance"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Database Instance List";
    LookupPageId = "Database Instance List";

    fields
    {
        field(1; "NST Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Server Instance Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Database Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Database Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Server Instance Path"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(6; State; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Version; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Web Client URL"; Text[500])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
    }

    keys
    {
        key(Key1; "NST Server", "Server Instance Name")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}