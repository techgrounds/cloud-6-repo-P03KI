targetScope = 'resourceGroup'

param kvVar object
param vnetVar object
param clientVar object
param tags object
// param vnetId0 string 
// param vnetId1 string
param stgType string
param stgName string
param filename string = 'Bootscript_Linux.sh'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing= {
  name: clientVar.client
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
}

//////////////////// STORAGE /////////////////////////////////
resource sa 'Microsoft.Storage/storageAccounts@2021-08-01'={
  name:stgName
  tags:tags
  identity:{
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mngId.id}':{}
    }
  }
  location:clientVar.location
  sku: {
    name: stgType
  }
  kind:'StorageV2'
  properties:{

    accessTier:'Hot'
    minimumTlsVersion:'TLS1_2'
    allowSharedKeyAccess:true
    encryption:{
      identity:{
        userAssignedIdentity: mngId.id
      }
      keySource:'Microsoft.Keyvault'
      keyvaultproperties:{
        keyname:'RSAKey'
        keyvaulturi:kv.properties.vaultUri
      }
      services:{
        blob:{
          enabled:true
          keyType:'Account'
        }
        file:{
          enabled:true
          keyType:'Account'
        }
        queue:{
          enabled:true
          keyType:'Account'
        }
        table:{
          enabled:true
          keyType:'Account'
        }
      }
    }
    networkAcls:{
      defaultAction:'Allow'
      bypass:'AzureServices'
    }
  }
}

resource stgblob 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01'= {
  parent: sa
  name: 'default'
  properties:{
    containerDeleteRetentionPolicy:{
      enabled: true
      days: 30
    }
    deleteRetentionPolicy:{
      enabled: true
      days: 30
    }
    automaticSnapshotPolicyEnabled:true
    isVersioningEnabled: true
    restorePolicy:{
      enabled: true
      days:7
    }
    changeFeed: {
      enabled: true
      retentionInDays: 14
    }
  }
}

resource stgblobcnt 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01'={
  parent: stgblob
  name: 'bootstrapdata'
  properties: {
    publicAccess: 'Container'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'upSsh'
  location: clientVar.location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'P1D'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: stgName
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: sa.listKeys().keys[0].value
      }
      {
        name: 'CONTENT'
        value: loadFileAsBase64('../etc/apache_install.sh')
      }
    ]
    scriptContent: 'echo "$CONTENT" | base64 -d > ${filename} && az storage blob upload -f ${filename} -c bootstrapdata -n ${filename}' 
  }
}
