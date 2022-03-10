param clientVar object
param kvVar object
param tags object
param vnetVar object
@secure()
param pwd string
//- Reference
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]

//- Deploying KV
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
      defaultAction: 'Allow'
      bypass: 'AzureServices'
      virtualNetworkRules:[
        {
            id: '${vnet[0].id}/subnets/subnet0'
        }       
        {
            id: '${vnet[1].id}/subnets/subnet1'      
        }
    ]
    }
  }
}

resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: clientVar.client
  location: clientVar.location
  tags:tags
  dependsOn:[
    kv
  ]
}

//--------------------- Create Keys ------------------------------------------
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  parent: kv
  tags: tags
  name: 'genPass'
  properties: {
    value: pwd
  }
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
        }    
      }
    ]
  }
}
