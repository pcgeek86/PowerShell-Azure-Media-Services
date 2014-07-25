function Get-AzureMediaServicesProcessor {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name
       ,[Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext] $Context
    )

    # Obtain a reference to the media encoder
    $MediaProcessor = ($Context.MediaProcessors.Where({ $PSItem.Name -eq $Name; }) | Sort-Object -Property Version)[-1];

    if (!$MediaProcessor) {
        throw 'An invalid media processor name was specified. Please choose from one of the following: {0}' -f $Context.MediaProcessors.Name;
    }
    
    return $MediaProcessor;
}