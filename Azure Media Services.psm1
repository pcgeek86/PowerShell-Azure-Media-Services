. $PSScriptRoot\Get-AzureMediaContext.ps1;
. $PSScriptRoot\Load-AzureMediaDependencies.ps1;
. $PSScriptRoot\New-AzureMediaAsset.ps1;
. $PSScriptRoot\Get-AzureMediaProcessor.ps1;
. $PSScriptRoot\Add-AzureAssetFile;
. $PSScriptRoot\Get-AzureMediaServicesProcessor;

$PublicFunction = @(
    'Get-AzureMediaContext';
    'New-AzureMediaAsset';
    'Get-AzureMediaProcessor';
    'Add-AzureAssetFile';
    'Get-AzureMediaServicesProcessor';
    );
Export-ModuleMember -Function $PublicFunction;

Load-AzureMediaDependencies;