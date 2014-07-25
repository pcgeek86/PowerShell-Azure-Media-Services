<#
    NOTE: This file simply makes it easy to import the module from
          any filesystem path, without adding the directory to the
          $env:PSModulePath environment variable.
#>
Clear-Host;
$ModuleName = Split-Path -Path $PSScriptRoot -Leaf;
Remove-Module -Name $ModuleName -ErrorAction SilentlyContinue;
Import-Module -Name ('{0}\{1}.psd1' -f $PSScriptRoot, $ModuleName) -Verbose;