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

    procedure SelectAppandDeploy()
    var
        Application: Record Application;
    begin
        if Application.IsEmpty then begin
            AppManagement.ImportAppFileandDeploy("Server Instance Name");
            exit;
        end;
        if Page.RunModal(0, Application) = Action::LookupOK then
            if Application."App Folder Location" = '' then
                AppManagement.ImportAppFileandDeploy("Server Instance Name")
            else
                AppManagement.FindAppFileandDeploy(Rec, Application)
    end;

}