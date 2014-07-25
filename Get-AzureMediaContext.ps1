function Get-AzureMediaContext {
    <#
    .Synopsis
    Creates a new Azure Media Context, with the given ACS token or account details.

    .Parameter TokenPath
    The path to the JSON file that contains the serialized Access Control Services (ACS) token. If
    you do not already have an ACS token, then you can create one by using the 'NewToken' parameter set.

    If you are creating a new token, using the 'NewToken' parameter set, then this parameter will be used

    .Parameter FromToken
    Loads an ACS token from a file, instead of creating a new one. Only use this parameter along with the
    TokenPath parameter, if you have already created an ACS token and exported it to a file. By default,
    this command will export a new ACS token to a file, unless you suppress it with the -NoExport parameter.

    .Parameter AccountName
    The name of the Azure Media Services account that you will retrieve a context for.

    .Parameter Key
    The primary or secondary Azure Media Services account key that correlates to the account specified in
    the -AccountName parameter.

    .Parameter NoExport
    Prevents the credentials (ACS token) for the CloudMediaContext from being exported to a file.

    .Example
    Get a new CloudMediaContext using an Azure Media Services account name and key.

    $Context = Get-AzureMediaContext -AccountName JoesMedia -Key <keyhere>;
    #>
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'FromToken', Mandatory = $false)]
        [Parameter(ParameterSetName = 'NewToken', Mandatory = $false)]
        [ValidateScript({
            if (ConvertFrom-Json -InputObject (Get-Content -Path $PSItem)) { $true; }
            })]
        [string] $TokenPath = '{0}\MediaServicesToken.json' -f $PSScriptRoot
       ,[Parameter(ParameterSetName = 'NewToken', Mandatory = $true)]
        [ValidateScript({
            if (Get-AzureMediaServicesAccount -Name $PSItem) { $true; }
            })]
        [string] $AccountName
       ,[Parameter(ParameterSetName = 'NewToken', Mandatory = $true)]
        [string] $Key
       ,[Parameter(ParameterSetName = 'NewToken', Mandatory = $false)]
        [switch] $NoExport
       ,[Parameter(ParameterSetName = 'FromToken', Mandatory = $true)]
        [switch] $FromToken
    )

    # Get the command's name, to use for logging
    $CmdletName = $PSCmdlet.MyInvocation.MyCommand.Name;

    if ($PSCmdlet.ParameterSetName -eq 'FromToken') {
        Write-Verbose -Message ('Attempting to read ACS token from path: {0}' -f $TokenPath);
        $DeserializedACSToken = ConvertFrom-Json -InputObject (Get-Content -Path $TokenPath -Raw -ErrorAction Stop) -ErrorAction Stop;
        # Create the MediaServicesCredentials object
        $MediaServicesCredentials = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.MediaServicesCredentials -ArgumentList $DeserializedACSToken.ClientId, $DeserializedACSToken.ClientSecret, $DeserializedACSToken.Scope, $DeserializedACSToken.AcsBaseAddress -ErrorAction Stop;
        # Create the CloudMediaContext object
        $CloudMediaContext = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext -ArgumentList $MediaServicesCredentials -ErrorAction Stop;
        Write-Verbose -Message 'Successfully created CloudMediaContext from deserialized ACS token.';

        return $CloudMediaContext;
    }

    if ($PSCmdlet.ParameterSetName -eq 'NewToken') {
        Write-Verbose -Message 'Creating new Azure Media Services ACS token.'
        # Create the CloudMediaContext object
        $CloudMediaContext = New-Object -TypeName Microsoft.WindowsAzure.MediaServices.Client.CloudMediaContext -ArgumentList $AccountName, $Key;
        # Export the ACS token to a local file, to avoid unnecessary Active Directory requests
        
        if (!$NoExport) {
            Write-Verbose -Message ('{0}: Saving token to path: {1}' -f $CmdletName, $TokenPath);
            $CloudMediaContext.Credentials | ConvertTo-Json | Out-File -FilePath $TokenPath;
        }

        return $CloudMediaContext;
    }
}

if ($MyInvocation.MyCommand.Module) {
    Export-ModuleMember -Function Get-AzureMediaContext;
}