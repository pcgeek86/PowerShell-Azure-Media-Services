function Load-AzureMediaServicesDependencies {
    [CmdletBinding()]
    param ()

    Invoke-WebRequest -Uri http://nuget.org/nuget.exe -OutFile $PSScriptRoot\nuget.exe;

    # Install dependencies from NuGet, to work with Azure Media Services
    #Set-Location -Path $PSScriptRoot;
    $NuGetPackageList = @(
        @{ Name = 'TransientFaultHandling.Core'; Version = '5.1.1209'; };
        @{ Name = 'Microsoft.WindowsAzure.ConfigurationManager'; Version = '2.0.3'; };
        @{ Name = 'WindowsAzure.MediaServices'; Version = '3.0.0.1'; };
        @{ Name = 'WindowsAzure.Storage'; Version = '3.0.3'; };
        )
    $NuGetOutput = '{0}\Library' -f $PSScriptRoot;
    foreach ($NuGetPackage in $NuGetPackageList) {
        Write-Verbose -Message ('Installing NuGet package: {0} {1}' -f $NuGetPackage.Name, $NuGetPackage.Version);
        [void](nuget install $NuGetPackage.Name -Version $NuGetPackage.Version -OutputDirectory $NuGetOutput);
    }

    #region This is the old way of installing dependencies, with multiple calls to nuget.exe (duplicate code)
    #nuget install TransientFaultHandling.Core -Version 5.1.1209.1 -OutputDirectory $NuGetOutput;
    #nuget install Microsoft.WindowsAzure.ConfigurationManager -Version 2.0.3 -OutputDirectory $NuGetOutput;
    #nuget install WindowsAzure.MediaServices -Version 3.0.0.5 -OutputDirectory $NuGetOutput;
    #nuget install WindowsAzure.Storage -Version 3.0.3 -OutputDirectory $NuGetOutput;
    #endregion

    # NOTE: The Azure Media Services Extensions library requires a different tree of dependencies.
    #       Not worth the effort at this point in time.
    #nuget install Microsoft.WindowsAzure.Storage -Version 2.0.0.0 -OutputDirectory $NuGetOutput;
    #nuget install Microsoft.Data.Services.Client -Version 5.5.0.0 -OutputDirectory $NuGetOutput;
    #nuget install WindowsAzure.MediaServices -Version 3.0.0.1 -OutputDirectory $NuGetOutput;
    #nuget install windowsazure.mediaservices.extensions -Version 2.0.0.1 -OutputDirectory $NuGetOutput;

    # Load .NET libraries
    Add-Type -Path $NuGetOutput\WindowsAzure.Storage.3.0.3.0\lib\net40\Microsoft.WindowsAzure.Storage.dll;
    Add-Type -Path $NuGetOutput\TransientFaultHandling.Core.5.1.1209.1\lib\NET4\Microsoft.Practices.TransientFaultHandling.Core.dll;
    Add-Type -Path $NuGetOutput\windowsazure.mediaservices.3.0.0.5\lib\net40\Microsoft.WindowsAzure.MediaServices.Client.dll;
    #Add-Type -Path $NuGetOutput\windowsazure.mediaservices.3.0.0.1\lib\net40\Microsoft.WindowsAzure.MediaServices.Client.dll;
    #Add-Type -Path $NuGetOutput\windowsazure.mediaservices.extensions.2.0.0.1\lib\NET4\Microsoft.WindowsAzure.MediaServices.Client.Extensions.dll;

}