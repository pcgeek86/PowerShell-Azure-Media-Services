function Load-AzureMediaServicesDependencies {
    [CmdletBinding()]
    param (
        [switch] $Clean
    )

    $NuGet = '{0}\nuget.exe' -f $PSScriptRoot;
    if (!(Test-Path -Path $NuGet)) {
        Invoke-WebRequest -Uri http://nuget.org/nuget.exe -OutFile $NuGet;
    }

    # Install dependencies from NuGet, to work with Azure Media Services
    #Set-Location -Path $PSScriptRoot;
    $NuGetPackageList = @(
        @{ Name = 'Microsoft.Data.Services.Client'; Version = '5.6.3'; };
        @{ Name = 'Microsoft.Data.Edm'; Version = '5.6.3'; };
        @{ Name = 'System.Spatial'; Version = '5.6.3'; };
        @{ Name = 'Microsoft.Data.OData'; Version = '5.6.3'; };
        @{ Name = 'TransientFaultHandling.Core'; Version = '5.1.1209.1'; };
        @{ Name = 'Microsoft.WindowsAzure.ConfigurationManager'; Version = '2.0.3'; };
        @{ Name = 'Newtonsoft.Json'; Version = '6.0.6.0'; };
        @{ Name = 'WindowsAzure.Storage'; Version = '4.3.0'; };
        @{ Name = 'WindowsAzure.MediaServices'; Version = '3.1.0.1'; };
        )

    $NuGetOutput = '{0}\Library' -f $PSScriptRoot;

    if ($Clean) {
        Remove-Item -Path $NuGetOutput -Recurse;
    }

    foreach ($NuGetPackage in $NuGetPackageList) {
        Write-Verbose -Message ('Installing NuGet package: {0} {1}' -f $NuGetPackage.Name, $NuGetPackage.Version);
        [void](& $NuGet install $NuGetPackage.Name -Version $NuGetPackage.Version -OutputDirectory $NuGetOutput);
    }

    # Load .NET libraries
    Add-Type -Path $NuGetOutput\System.Spatial.5.6.3\lib\net40\System.Spatial.dll;
    Add-Type -Path $NuGetOutput\Microsoft.Data.Edm.5.6.3\lib\net40\Microsoft.Data.Edm.dll;
    Add-Type -Path $NuGetOutput\Microsoft.Data.OData.5.6.3\lib\net40\Microsoft.Data.OData.dll;
    Add-Type -Path $NuGetOutput\Microsoft.Data.Services.Client.5.6.3\lib\net40\Microsoft.Data.Services.Client.dll;
    Add-Type -Path $NuGetOutput\windowsazure.mediaservices.3.1.0.1\lib\net45\Microsoft.WindowsAzure.MediaServices.Client.dll;
}

Load-AzureMediaServicesDependencies;