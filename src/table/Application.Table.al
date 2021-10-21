/// <summary>
/// Table Application (ID 50101).
/// </summary>
table 50101 "Application"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Publisher; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Version; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; SkipVerification; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Existing Version"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "App File Path"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                AppManagement: Codeunit "App Management";
            begin
                AppManagement.ModifyTempApplication(ServerInstance, Rec);
            end;
        }
        field(8; "Delete File After Deployment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; ServerInstance; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}