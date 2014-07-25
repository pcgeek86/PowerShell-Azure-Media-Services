function New-AzureMediaAsset {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext] $Context
       ,[Parameter(Mandatory = $true)]
        [string] $Name
    )


}