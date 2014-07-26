PowerShell Azure Media Services Extensions
===============================

This project offers Azure Media Services automation capabilities that are missing from the core Azure PowerShell module.

Functions
===============

There are several functions available in this module:

* Get-AzureMediaServicesContext
* New-AzureMediaServicesAsset
* Add-AzureMediaServicesAssetFile
* Get-AzureMediaServicesProcessor

Process Flow for Azure Media Services
======================================

To get started using Azure Media Services, follow these steps:

1. Select the appropriate Azure subscription
2. Create an Azure Affinity Group
3. Create an Azure Storage Account
  * Associate the Storage Account with the Affinity Group
4. Create an Azure Media Services Account
  * Associate the Media Services Account with the Storage Account

```
$SubscriptionName = 'Visual Studio Ultimate with MSDN'; # This is case sensitive, unfortunately
Select-AzureSubscription -SubscriptionName 
```

Once you've created the Azure Media Services account, you can begin creating Assets.

An Azure Media Services **Asset** maps to a Storage Container within an Azure Storage Account.
An Azure Media Services **Asset File** maps to a blob within an Storage Container

