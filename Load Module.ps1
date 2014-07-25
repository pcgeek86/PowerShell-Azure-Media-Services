$ModuleName = Split-Path -Path $PSScriptRoot -Leaf;
Remove-Module -Name $ModuleName;
Import-Module -Name ('{0}\{1}.psd1' -f $PSScriptRoot, $ModuleName);