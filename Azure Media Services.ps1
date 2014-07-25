#requires -version 4.0
[CmdletBinding()]
param (
)

Clear-Host;
$VerbosePreference = 'Continue';

#region Declare variables for Azure Media Services script
$Subscription = 'Visual Studio Ultimate with MSDN';
$Location = 'West US';

$AffinityGroup = @{
    Name = 'TrevorMedia';
    Description = 'Affinity group for Azure Media Services.';
    Location = $Location;
    };
$StorageAccount = @{ 
    StorageAccountName = 'tbsmedia';
    Description = 'Storage Account used for Azure Media Services';
    AffinityGroup = $AffinityGroup.Name;
    };
$MediaAccount = @{
    Name = 'tbsmedia';
    Location = $Location;
    StorageAccountName = $StorageAccount.StorageAccountName;
    # TODO: Write function to retrieve the Media Services Account key from the Azure Service Management API
    PrimaryKey = 'D0tiT5hcPTSYgyDkoxKWbcSvmdX/YOC1s3cB4yUopuw=';
    };
#endregion

#region Create Azure resources
Select-AzureSubscription -SubscriptionName $Subscription;
# Create Affinity Group
if (!(Get-AzureAffinityGroup -Name $AffinityGroup.Name)) {
    New-AzureAffinityGroup @AffinityGroup -Verbose; };
# Create Storage Account
if (!(Get-AzureStorageAccount -StorageAccountName $StorageAccount.StorageAccountName)) { 
    New-AzureStorageAccount @StorageAccount -Verbose; };
# Create Media Services Account
if (!(Get-AzureMediaServicesAccount -Name $MediaAccount.Name)) { 
    New-AzureMediaServicesAccount @MediaAccount -Verbose; }
#endregion Create Azure resources

#region Dependencies
# Install dependencies from NuGet, to work with Azure Media Services
#Set-Location -Path $PSScriptRoot;
$NuGetPackageList = @(
    @{ Name = 'TransientFaultHandling.Core'; Version = '5.1.1209'; };
    @{ Name = 'Microsoft.WindowsAzure.ConfigurationManager'; Version = '2.0.3'; };
    @{ Name = 'WindowsAzure.MediaServices'; Version = '3.0.0.1'; };
    @{ Name = 'WindowsAzure.Storage'; Version = '3.0.3'; };
    )
$NuGetOutput = '{0}\Library' -f $PSScriptRoot;
foreach ($NuGetPackage in $NuGetPackageList) {
    Write-Verbose -Message ('Installing NuGet package: {0} {1}' -f $NuGetPackage.Name, $NuGetPackage.Version);
    [void](nuget install $NuGetPackage.Name -Version $NuGetPackage.Version -OutputDirectory $NuGetOutput);
}

#region This is the old way of installing dependencies, with multiple calls to nuget.exe (duplicate code)
#nuget install TransientFaultHandling.Core -Version 5.1.1209.1 -OutputDirectory $NuGetOutput;
#nuget install Microsoft.WindowsAzure.ConfigurationManager -Version 2.0.3 -OutputDirectory $NuGetOutput;
#nuget install WindowsAzure.MediaServices -Version 3.0.0.5 -OutputDirectory $NuGetOutput;
#nuget install WindowsAzure.Storage -Version 3.0.3 -OutputDirectory $NuGetOutput;
#endregion

# NOTE: The Azure Media Services Extensions library requires a different tree of dependencies.
#       Not worth the effort at this point in time.
#nuget install Microsoft.WindowsAzure.Storage -Version 2.0.0.0 -OutputDirectory $NuGetOutput;
#nuget install Microsoft.Data.Services.Client -Version 5.5.0.0 -OutputDirectory $NuGetOutput;
#nuget install WindowsAzure.MediaServices -Version 3.0.0.1 -OutputDirectory $NuGetOutput;
#nuget install windowsazure.mediaservices.extensions -Version 2.0.0.1 -OutputDirectory $NuGetOutput;

# Load .NET libraries
Add-Type -Path $NuGetOutput\WindowsAzure.Storage.3.0.3.0\lib\net40\Microsoft.WindowsAzure.Storage.dll;
Add-Type -Path $NuGetOutput\TransientFaultHandling.Core.5.1.1209.1\lib\NET4\Microsoft.Practices.TransientFaultHandling.Core.dll;
Add-Type -Path $NuGetOutput\windowsazure.mediaservices.3.0.0.5\lib\net40\Microsoft.WindowsAzure.MediaServices.Client.dll;
#Add-Type -Path $NuGetOutput\windowsazure.mediaservices.3.0.0.1\lib\net40\Microsoft.WindowsAzure.MediaServices.Client.dll;
#Add-Type -Path $NuGetOutput\windowsazure.mediaservices.extensions.2.0.0.1\lib\NET4\Microsoft.WindowsAzure.MediaServices.Client.Extensions.dll;
#endregion

#region CloudMediaContext
# Define a path to hold the ACS token persisted to disk
$TokenPath = '{0}\MediaServicesToken.json' -f $PSScriptRoot;
try {
    Write-Verbose -Message ('Attempting to read ACS token from path: {0}' -f $TokenPath);
    $DeserializedACSToken = ConvertFrom-Json -InputObject (Get-Content -Path $TokenPath -Raw -ErrorAction Stop) -ErrorAction Stop;
    # Create the MediaServicesCredentials object
    $MediaServicesCredentials = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.MediaServicesCredentials -ArgumentList $DeserializedACSToken.ClientId, $DeserializedACSToken.ClientSecret, $DeserializedACSToken.Scope, $DeserializedACSToken.AcsBaseAddress -ErrorAction Stop;
    # Create the CloudMediaContext object
    $CloudMediaContext = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext -ArgumentList $MediaServicesCredentials -ErrorAction Stop;
    Write-Verbose -Message 'Successfully created CloudMediaContext from deserialized ACS token.';
}
catch {
    Write-Verbose -Message 'Creating new ACS token, since one was not found.'
    # Create the CloudMediaContext object
    $CloudMediaContext = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext -ArgumentList $MediaAccount.Name, $MediaAccount.PrimaryKey;
    # Export the ACS token to a local file, to avoid unnecessary Active Directory requests
    $CloudMediaContext.Credentials | ConvertTo-Json | Out-File -FilePath $TokenPath;
    # Import the ACS token from the local file, to avoid requesting a new token

}
#endregion

#region Asset construction
# Define structure of new asset
$Asset = @{
    Name = 'TestAsset';
    FileList = @(
        @{
            Name = 'TestVideo.wmv';
            Source = '{0}\TestVideo.wmv' -f $PSScriptRoot;
        };
        );
    };
# Create a new Asset (maps to storage container)
if (!($NewAsset = $CloudMediaContext.Assets.Where({ $PSItem.Name -eq $Asset.Name}))) {
    Write-Verbose -Message ('Creating new asset named: {0}' -f $Asset.Name);
    $NewAsset = $CloudMediaContext.Assets.Create($Asset.Name, [Microsoft.WindowsAzure.MediaServices.Client.AssetCreationOptions]::None);
};

# Upload all files to Asset
foreach ($File in $Asset.FileList) {
    # If the file name already exists as an Azure Asset File, then skip it
    if (@($NewAsset.AssetFiles).Where({ $PSItem.Name -eq $File.Name; })) {
        Write-Verbose -Message ('File {0} already exists in asset {1}' -f $File.Name, $NewAsset.Name);
        continue; };
    Write-Verbose -Message ('Uploading file {0} to asset {1}' -f $File.Name, $Asset.Name);

    # Create a new Azure Asset File
    $NewFile = $NewAsset.AssetFiles.Create($File.Name);
    # Upload the local file to the Azure Asset File
    $NewFile.Upload($File.Source);
    $NewFile = $null;
}
#endregion

#region Perform asset encoding
$MediaProcessor = 'Windows Azure Media Encoder';
# Obtain a reference to the media encoder
$Encoder = ($CloudMediaContext.MediaProcessors.Where({ $PSItem.Name -eq $MediaProcessor; }) | Sort-Object -Property Version)[-1];
$EncodingJob = $CloudMediaContext.Jobs.Create('Convert WMV to MP4');
#endregion