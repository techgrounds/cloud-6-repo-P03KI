param clientVar object
param kvVar object
param tags object
param vnetVar object

//- Reference
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]
//- Deploying KV
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
}
//- Create managed ID
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: clientVar.client
  location: clientVar.location
  tags:tags
  dependsOn:[
    kv
  ]
}
resource RSAKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' = {
  name: 'RSAKey'
  parent: kv
  tags: tags
  properties:{
    kty: 'RSA'
    keySize: 4096
    keyOps:[
      'unwrapKey'
      'wrapKey'
      'decrypt'
      'encrypt'
      'verify'
      'sign'
    ]
    attributes:{
      enabled:true
    }
  }
}
resource dskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
  name: 'dskEncrKey-${clientVar.client}'
  location: clientVar.location
  tags:tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    rotationToLatestKeyVersionEnabled:true
    activeKey: {
      keyUrl: RSAKey.properties.keyUriWithVersion
      sourceVault: {
        id: kv.id
      }
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
  }
}
//- Define policy
resource kvPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01'= {
  name: 'add'
  parent: kv
  properties:{
    accessPolicies:[
      {
        tenantId: kvVar.tenantId
        objectId: dskEncrKey.identity.principalId
        permissions:{
          keys:[
            'all'
          ]
          storage:[
            'all'
          ]
          secrets:[
            'all'
          ]
        } 
      }
      {
        tenantId: kvVar.tenantId
        objectId: mngId.properties.principalId
        permissions: {
          keys: [
            'all'
          ]
          storage: [
            'all'
          ]
          secrets:[
            'all'
          ]
          certificates:[
            'all'
          ]
        }    
      }
    ]
  }
}
