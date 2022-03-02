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
param stgType string
param blobEncryptionEnabled bool = true
param location string
param stgName string

resource sa 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: stgName
  location: location
  sku: {
    name: stgType
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

output stgName string = sa.name
output storageAccountId string = sa.id
