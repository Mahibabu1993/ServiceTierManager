/// <summary>
/// Table PowerShell Setup (ID 50103).
/// </summary>
table 50103 "PowerShell Setup"
{
    Caption = 'General Ledger Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "UserName"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Password"; Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(4; "Use File Path for Deploment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Shared Folder Path"; Text[500])
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