param clientVar object
param kvVar object
param subId1 string
param subId2 string
param tags object
param vnetVar object

resource vnet0 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[0]
}
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[1]
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: kvVar.kvName
  location: kvVar.location
  tags:tags
  properties:{
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableRbacAuthorization: false
    tenantId:  kvVar.tenantId
    ////////// Temporary for testdeployments ///////////////////////
    enablePurgeProtection: true
    enableSoftDelete: true
    //////////////////////////////////////////////////////////////
    accessPolicies:[
      {
        objectId: kvVar.objectId
        tenantId: kvVar.tenantId
        permissions:{
          keys:[
            'all'
          ]
          secrets:[
            'all'
          ]
          storage:[
            'all'
          ]
          certificates:[
            'all'
          ]
        }
      }
    ]
    sku:{
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules:[
        {
            id: subId1
        }       
        {
            id: subId2        
        }
    ]
    }
  }
}

resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: clientVar.client
  location: clientVar.location
  tags:tags
}

//--------------------- Create Keys ------------------------------------------
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: kv
  name: 'ssh'
  properties: {
    value: loadTextContent('../etc/SSHKey.pub')
  }
}
resource RSAKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' = {
  name: 'RSAKey'
  parent: kv
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
        }    
      }
    ]
  }
}
output kvId string = kv.id
output dskEncrId string = dskEncrKey.id
output kvUri string = kv.properties.vaultUri
output mngId string = mngId.id
output mngName string = mngId.name
