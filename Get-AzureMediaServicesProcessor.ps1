function Get-AzureMediaServicesProcessor {
    <#
    .Synopsis
    Retrieves the specified Azure Media Services Processor, or lists the available ones.

    .Parameter Name
    The name of the Azure Media Services Processor that will be retrieved. If you do not know
    which ones are available, use the -ListAvailable parameter.

    .Parameter ListAvailable
    Lists the available media processors for the specified Azure Media Services context.

    .Parameter Context
    The Azure Media Services context that will be used to retrieve a media processor. You can
    retrieve a context using the Get-AzureMediaServicesContext command.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [string] $Name
       ,[Parameter(Mandatory = $false, ParameterSetName = 'ByName')]
        [string] $Version
       ,[Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ByName')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ListAvailable')]
        [Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext] $Context
       ,[Parameter(Mandatory = $true, ParameterSetName = 'ListAvailable')]
        [switch] $ListAvailable
    )

    # Return a list of Media Processors
    if ($PSCmdlet.ParameterSetName -eq 'ListAvailable') {
        return $Context.MediaProcessors;
    }

    # Obtain a reference to the media processor
    if ($Version) {
        # Get the specific media processor name and version.
        $MediaProcessor = $Context.MediaProcessors.Where({ $PSItem.Name -eq $Name -and $PSItem.Version -eq $Version });
    }
    else {
        $MediaProcessor = ($Context.MediaProcessors.Where({ $PSItem.Name -eq $Name; }) | Sort-Object -Property Version)[-1];
    }

    if (!$MediaProcessor) {
        throw 'An invalid media processor name was specified. Please choose from one of the following: {0}' -f ($Context.MediaProcessors.Name -join ', ');
    }
    
    return $MediaProcessor;
}