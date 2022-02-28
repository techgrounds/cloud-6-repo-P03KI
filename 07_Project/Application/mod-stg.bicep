// @description('Specifies the name of the Azure Storage account.')
// param storageAccountName string

// @description('Specifies the name of the blob container.')
// param containerName string = 'bootscripts'

// @description('Specifies the location in which the Azure Storage resources should be deployed.')
// param location string

@description('Storage Account type.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string
param blobEncryptionEnabled bool = true
param location string
param storageAccountName string

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: blobEncryptionEnabled
        }
      }
    }
  }
}

output storageAccountName string = sa.name
output storageAccountId string = sa.id

// resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
//   name: storageAccountName
//   location: location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
//   properties: {
//     accessTier: 'Hot'
//   }
// }

// resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
//   name: '${sa.name}/default/${containerName}'
// }
