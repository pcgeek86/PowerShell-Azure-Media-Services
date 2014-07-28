PowerShell Azure Media Services Extensions
===============================

This project offers Azure Media Services automation capabilities that are missing from the core Azure PowerShell module.

Functions
---------------

There are several functions available in this module:

* Get-AzureMediaServicesContext
* New-AzureMediaServicesAsset
* Add-AzureMediaServicesAssetFile
* Get-AzureMediaServicesProcessor

Process Flow for Azure Media Services
---------------------------------------

To get started using Azure Media Services, follow these steps:

1. Select the appropriate Azure subscription
2. Create an Azure Affinity Group
3. Create an Azure Storage Account
  * Associate the Storage Account with the Affinity Group
4. Create an Azure Media Services Account
  * Associate the Media Services Account with the Storage Account

```
$SubscriptionName = 'Visual Studio Ultimate with MSDN'; # This is case sensitive, unfortunately
Select-AzureSubscription -SubscriptionName $SubscriptionName;

# Create an Affinity Group
New-AzureAffinityGroup -Name MyAffinityGroup -Location 'West US';

# Create a Storage Account
New-AzureStorageAccount -StorageAccountName storage123 -AffinityGroup MyAffinityGroup;

# Create a Media Services Account
New-AzureMediaServicesAccount -Name mediaservice -Location 'North Central US' -StorageAccountName storage123;
```

Assets
-------

Once you've created the Azure Media Services account, you can begin creating Assets.

An Azure Media Services **Asset** maps to a Storage Container within an Azure Storage Account.
An Azure Media Services **Asset File** maps to a blob within an Storage Container

1. Get a Azure Media Services Context
2. Create an Asset in the Media Services Context
3. Create and upload Asset Files to the Asset

Jobs
-------

After creating an Azure Media Services Asset, you can begin executing Jobs on it. Jobs are used for a variety of tasks in the Azure Media Services platform. For example, jobs are used to encode media into a different format.

1. Create a Job
2. Create a Task
  * Add input Assets to the Task
  * Add output Assets to the Task
3. Submit the Job and wait for completion