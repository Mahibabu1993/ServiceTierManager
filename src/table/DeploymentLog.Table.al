table 50102 "Deployment Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "App Publisher"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "App Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Database Instance Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "NST Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Server Instance Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Database Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Database Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Date; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "User Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Type; Enum LogType)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Details; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
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

    [Scope('OnPrem')]
    procedure CreateInfoEntry(Msg: Text[250])
    begin
        CreateEntry(Msg, false, '')
    end;

    [Scope('OnPrem')]
    procedure CreateInfoEntryWithDetails(Msg: Text[250]; LogDetails: Text)
    begin
        CreateEntry(Msg, false, LogDetails)
    end;

    [Scope('OnPrem')]
    procedure CreateErrorEntry(Msg: Text[250])
    begin
        CreateEntry(Msg, true, '')
    end;

    [Scope('OnPrem')]
    procedure CreateErrorEntryWithDetails(Msg: Text[250]; LogDetails: Text)
    begin
        CreateEntry(Msg, true, LogDetails)
    end;

    local procedure CreateEntry(Msg: Text[250]; IsErrorEntry: Boolean; LogDetails: Text)
    var
        BlobOutStream: OutStream;
    begin
        Init;
        ID := 0;
        "App Name" := CopyStr(Msg, 1, MaxStrLen("App Name"));
        Date := CurrentDateTime;
        "User Name" := UserId;

        Details.CreateOutStream(BlobOutStream);
        BlobOutStream.Write(LogDetails);

        if IsErrorEntry then
            Type := Type::Error
        else
            Type := Type::Information;

        Insert
    end;

    [Scope('OnPrem')]
    procedure GetDetailsText() DetailsText: Text
    var
        DetailsIn: InStream;
    begin
        CalcFields(Details);
        Details.CreateInStream(DetailsIn);
        DetailsIn.Read(DetailsText);
    end;

}