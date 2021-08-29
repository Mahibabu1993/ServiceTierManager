table 50102 "PowerShell Log"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "PowerShell Command"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Date; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "User Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Type; Enum LogType)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Details; Blob)
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
    procedure CreateInfoEntry(Msg: Text[500])
    begin
        CreateEntry(Msg, false, '')
    end;

    [Scope('OnPrem')]
    procedure CreateInfoEntryWithDetails(Msg: Text[500]; LogDetails: Text)
    begin
        CreateEntry(Msg, false, LogDetails)
    end;

    [Scope('OnPrem')]
    procedure CreateErrorEntry(Msg: Text[500])
    begin
        CreateEntry(Msg, true, '')
    end;

    [Scope('OnPrem')]
    procedure CreateErrorEntryWithDetails(Msg: Text[500]; LogDetails: Text)
    begin
        CreateEntry(Msg, true, LogDetails)
    end;

    local procedure CreateEntry(Msg: Text[500]; IsErrorEntry: Boolean; LogDetails: Text)
    var
        BlobOutStream: OutStream;
    begin
        Init;
        ID := 0;
        "Powershell Command" := Msg;
        Date := CurrentDateTime;
        "User Name" := UserId;

        Details.CreateOutStream(BlobOutStream);
        BlobOutStream.Write(LogDetails);

        if IsErrorEntry then
            Type := Type::Error
        else
            Type := Type::Information;

        Insert();
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