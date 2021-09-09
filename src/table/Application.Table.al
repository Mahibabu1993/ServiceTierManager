/// <summary>
/// Table Application (ID 50101).
/// </summary>
table 50101 "Application"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Publisher; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Version; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; SkipVerification; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Existing Version"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "App File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Publisher, Name)
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