function Get-AzureMediaProcessor {
    [CmdletBinding()]
    param (
          [Parameter(Mandatory = $true)]
          [ValidateScript({
            
            })]
          [string] $Name
        , [string] $Version
    )

    return $MediaProcessor;
}