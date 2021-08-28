dotnet
{
    assembly("Microsoft.Dynamics.Nav.PowerShellRunner")
    {
        Culture = 'neutral';
        PublicKeyToken = '31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.PowerShellRunner"; "PowerShellRunner")
        {
        }

        type("Microsoft.Dynamics.Nav.PSObjectAdapter"; "PSObjectAdapter")
        {
        }
    }

    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Collections.IEnumerator"; "IEnumerator")
        {
        }

        type("System.Collections.Generic.IEnumerator`1"; "IEnumerator_Of_T")
        {
        }

        type("System.Version"; "Version")
        {
        }
    }
}