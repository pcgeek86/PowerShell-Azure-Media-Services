function Test-GetAzureMediaServicesContext {
    [CmdletBinding()]
    param ()

    $VerbosePreference = 'continue';
    $ErrorActionPreference = 'stop';

    $SubscriptionName = 'Visual Studio Ultimate with MSDN';
    $ModuleName = 'Azure Media Services';
    $AccountName = 'tbsmedia';

    # Select the appropriate Azure subscription
    Select-AzureSubscription -SubscriptionName $SubscriptionName -ErrorAction Stop;

    # Remove and reload module
    Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue;
    & ('{0}\..\Load Module.ps1' -f $PSScriptRoot);

    #$Context = Get-AzureMediaServicesContext -TokenPath ("$PSScriptRoot\..\MediaServicesToken.json") -FromToken -Verbose;
    $AccountKey = New-AzureMediaServicesKey -Name $AccountName -KeyType Primary -Force;
    $Context = Get-AzureMediaServicesContext -AccountName $AccountName -Key $AccountKey;
    Write-Output -InputObject $Context;
}

$Context = Test-GetAzureMediaServicesContext;