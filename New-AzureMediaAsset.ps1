function New-AzureMediaAsset {
    <#
    .Synopsis 
    Adds a new Asset to the specific
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'NoEncryption')]
        [Parameter(Mandatory = $true, ParameterSetName = 'CommonEncryptionProtected')]
        [Parameter(Mandatory = $true, ParameterSetName = 'StorageEncrypted')]
        [ValidateScript({
            $PSItem.Credentials.TokenExpiration -gt (Get-Date);
            })]
        [Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext] $Context
       ,[Parameter(Mandatory = $true, ParameterSetName = 'NoEncryption')]
        [Parameter(Mandatory = $true, ParameterSetName = 'CommonEncryptionProtected')]
        [Parameter(Mandatory = $true, ParameterSetName = 'StorageEncrypted')]
        [string] $Name
       ,[Parameter(Mandatory = $false, ParameterSetName = 'CommonEncryptionProtected')]
        [switch] $CommonEncryptionProtected
       ,[Parameter(Mandatory = $false, ParameterSetName = 'StorageEncrypted')]
        [switch] $StorageEncrypted
    )

    # Get the command name for logging
    $CmdletName = $PSCmdlet.MyInvocation.MyCommand.Name;

    if ($PSCmdlet.ParameterSetName -eq 'StorageEncrypted') {
        $AssetOption = [Microsoft.WindowsAzure.MediaServices.Client.AssetCreationOptions]::StorageEncrypted;
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'StorageEncrypted') {
        $AssetOption = [Microsoft.WindowsAzure.MediaServices.Client.AssetCreationOptions]::StorageEncrypted;
    }

    Write-Verbose -Message ('{0}: Creating new Azure Media Services asset named {1} in Media Services Account named {2}' -f $CmdletName, $Name, $Context.Credentials.ClientId);
    if (!($NewAsset = $CloudMediaContext.Assets.Where({ $PSItem.Name -eq $Asset.Name}))) {
        $NewAsset = $CloudMediaContext.Assets.Create($Asset.Name, [Microsoft.WindowsAzure.MediaServices.Client.AssetCreationOptions]::None);
    }
    else {
        # TODO: Handle multiple assets with the same name, which is supported by the Azure Media Services platform
        throw 'An asset with the same name already exists!' -f $Name;
    }    

    # Return the new Asset object
    return $NewAsset;
}

if ($MyInvocation.MyCommand.Module) {
    Export-ModuleMember -Function New-AzureMediaAsset;
}