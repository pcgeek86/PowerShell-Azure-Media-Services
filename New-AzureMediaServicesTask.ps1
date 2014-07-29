function New-AzureMediaServicesTask {
    [CmdletBinding()]
    [OutputType([Microsoft.WindowsAzure.MediaServices.Client.ITask])]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.IJob] $Job
       ,[Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.IMediaProcessor] $MediaProcessor
       ,[Parameter(Mandatory = $false)]
        [string] $Configuration = ''
       ,[Parameter(Mandatory = $true)]
        [string] $Name
    )

    [Microsoft.WindowsAzure.MediaServices.Client.IJob].GetProperty('Tasks').GetValue($Job).AddNew($Name, $Processor, '', [Microsoft.WindowsAzure.MediaServices.Client.TaskOptions]::None);
}