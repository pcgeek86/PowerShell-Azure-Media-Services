<#
    NOTE: This file simply makes it easy to import the module from
          any filesystem path, without adding the directory to the
          $env:PSModulePath environment variable.
#>
Clear-Host;

$Manifest = Get-ChildItem -Path $PSScriptRoot -Filter *.psd1;

Import-Module -Name $Manifest.FullName;