table 50101 "Application"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Publisher; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "App Folder Location"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Name, Publisher)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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