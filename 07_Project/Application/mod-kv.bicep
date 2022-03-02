param kvObj object
param skuName string = 'standard'

// param secretName string
// @secure()
// param secretValue string

// resource ssh 'Microsoft.KeyVault/vaults/keys@2021-10-01' ={
//   name: secretValue
//   location: location
//   properties:{
//     publicKey: secret 

//   }
// }
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: kvObj.keyVaultName
  location: kvObj.location
  properties: {
    enabledForDeployment: kvObj.enabledForDeployment
    enabledForDiskEncryption: kvObj.enabledForDiskEncryption
    enabledForTemplateDeployment: kvObj.enabledForTemplateDeployment
    tenantId: kvObj.tenantId
    
    ////////// Temporay for testdeployments ///////////////////////
    enablePurgeProtection:false
    enableSoftDelete: false
    //////////////////////////////////////////////////////////////
    accessPolicies: [
      {
        objectId: kvObj.objectId
        tenantId: kvObj.tenantId
        permissions: {
          keys: kvObj.keysPermissions
          secrets: kvObj.secretsPermissions
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

resource ssh_web 'Microsoft.Compute/sshPublicKeys@2021-11-01' = {
  name: 'ssh_web'
  location: kvObj.location
  properties: {
    publicKey: kvObj.pub
  }
}

output kvo object = kv

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
// resource secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
//   parent: kv
//   name: secretName
//   properties: {
//     value: secretValue
//   }
// }
