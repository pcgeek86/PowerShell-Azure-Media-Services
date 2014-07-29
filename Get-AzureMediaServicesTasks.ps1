function Get-AzureMediaServicesTask {
    <#
    .Parameter Job
    The Azure Media Services Job that the Tasks will be returned from.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.IJob] $Job
    )

    return [Microsoft.WindowsAzure.MediaServices.Client.IJob].GetProperty('Tasks').GetValue($Job);
}