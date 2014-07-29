function Test-GetAzureMediaServicesProcessor {
    $VerbosePreference = 'continue';

    $ModuleName = 'Azure Media Services';
    $AccountName = 'tbsmedia';

    # Remove and reload module
    Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue;
    & ('{0}\..\Load Module.ps1' -f $PSScriptRoot);

    # Refresh the Azure Media Services Account's Primary Key (password)
    $AccountKey = New-AzureMediaServicesKey -Name $AccountName -KeyType Primary -Force;
    # Create the Azure Media Services Context
    $Context = Get-AzureMediaServicesContext -AccountName $AccountName -Key $AccountKey;

    $MediaProcessor = $Context | Get-AzureMediaServicesProcessor -Name 'Windows Azure Media Encoder' -Version 3.10;
    Write-Output -InputObject $MediaProcessor;
}

$MediaProcessor = Test-GetAzureMediaServicesProcessor;