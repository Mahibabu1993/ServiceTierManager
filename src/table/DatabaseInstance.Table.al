table 50100 "Database Instance"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Database Instance List";
    DrillDownPageId = "Database Instance List";

    fields
    {
        field(1; Name; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "NST Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Server Instance Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Server Instance Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Database Type"; Enum DatabaseType)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Database Server"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Database Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Name)
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

    procedure SelectAppandDeploy()
    var
        Application: Record Application;
    begin
        if Application.IsEmpty then begin
            AppManagement.ImportAppFileandDeploy(Rec);
            exit;
        end;
        if Page.RunModal(0, Application) = Action::LookupOK then
            if Application."App Folder Location" = '' then
                AppManagement.ImportAppFileandDeploy(Rec)
            else
                AppManagement.FindAppFileandDeploy(Rec, Application)
    end;

}