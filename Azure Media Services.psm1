. $PSScriptRoot\Get-AzureMediaServicesContext.ps1;
. $PSScriptRoot\Load-AzureMediaServicesDependencies.ps1;
. $PSScriptRoot\New-AzureMediaServicesAsset.ps1;
. $PSScriptRoot\Get-AzureMediaServicesProcessor.ps1;
. $PSScriptRoot\Add-AzureMediaServicesAssetFile;

$PublicFunction = @(
    'Get-AzureMediaServicesContext';
    'New-AzureMediaServicesAsset';
    'Get-AzureMediaServicesProcessor';
    'Add-AzureMediaServicesAssetFile';
    );
Export-ModuleMember -Function $PublicFunction;

Load-AzureMediaServicesDependencies;

