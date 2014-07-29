function Test-GetAzureMediaServicesContext {
    $VerbosePreference = 'continue';

    $ModuleName = 'Azure Media Services';
    $AccountName = 'tbsmedia';

    # Remove and reload module
    Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue;
    & ('{0}\..\Load Module.ps1' -f $PSScriptRoot);

    #$Context = Get-AzureMediaServicesContext -TokenPath ("$PSScriptRoot\..\MediaServicesToken.json") -FromToken -Verbose;
    $AccountKey = New-AzureMediaServicesKey -Name $AccountName -KeyType Primary -Force;
    $Context = Get-AzureMediaServicesContext -AccountName $AccountName -Key $AccountKey;
    Write-Output -InputObject $Context;
}

$Context = Test-GetAzureMediaServicesContext;