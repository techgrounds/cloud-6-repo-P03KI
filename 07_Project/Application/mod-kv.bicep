param keyVaultName string
param location string
param enabledForDeployment bool = true
param enabledForDiskEncryption bool = true
param enabledForTemplateDeployment bool = true
param tenantId string = subscription().tenantId
param objectId string

@description('all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge')
param keysPermissions array = [
  'all'
]

@description('all, get, list, set, delete, backup, restore, recover, and purge')
param secretsPermissions array = [
  'all'
]
param skuName string = 'standard'
param secretName string

@secure()
param secretValue string

// resource ssh 'Microsoft.KeyVault/vaults/keys@2021-10-01' ={
//   name: secretValue
//   location: location
//   properties:{
//     publicKey: secret 

//   }
// }
resource kv 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
// resource kv_Policy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
//   name: 'add'
//   parent: kv
//   properties: {
//     accessPolicies: [
//       {
//         //applicationId: 'string'
//         objectId: objectId
//         permissions: {
//           certificates: [
//             'all'
//           ]
//           keys: [
//             'all'
//           ]
//           secrets: [
//             'all'
//           ]
//           storage: [
//             'all'
//           ]
//         }
//         tenantId: tenantId
//       }
//     ]
//   }
// }
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
  parent: kv
  name: secretName
  properties: {
    value: secretValue
  }
}
