table 50100 "Database Instance"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Database Instance List";
    DrillDownPageId = "Database Instance List";

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
        field(5; "Server Instance Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "NST Server", "Server Instance Name")
        {
            Clustered = true;
        }
    }

    var
        AppManagement: Codeunit "App Management";

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