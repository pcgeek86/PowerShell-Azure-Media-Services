function Add-AzureAssetFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name
       ,[Parameter(Mandatory = $true)]
        [string] $Path
       ,[Parameter(Mandatory = $true)]
        [Microsoft.WindowsAzure.MediaServices.Client.AssetData] $Asset
    )
    
    $CmdletName = $PSCmdlet.MyInvocation.MyCommand.Name;

    if (@($Asset.AssetFiles).Where({ $PSItem.Name -eq $Name; })) {
        Write-Verbose -Message ('File {0} already exists in asset {1}' -f $File.Name, $NewAsset.Name);
        return;
    }

    Write-Verbose -Message ('Uploading file {0} to asset {1}' -f $File.Name, $Asset.Name);
    # Create a new Azure Asset File
    $NewFile = $NewAsset.AssetFiles.Create($File.Name);
    # Upload the local file to the Azure Asset File
    $NewFile.Upload($File.Source);

    return $NewFile;
}

if ($MyInvocation.MyCommand.Module) {
    Export-ModuleMember -Function Add-AzureAssetFile;
}