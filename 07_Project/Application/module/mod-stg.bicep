targetScope = 'resourceGroup'

param clientVar object
param mngId string
param tags object
param stgType string
param stgName string
param subId1 string
param subId2 string
param kvUri string
param filename string = 'Bootscript_Linux.sh'

resource sa 'Microsoft.Storage/storageAccounts@2021-08-01'={
  name:stgName
  tags:tags
  identity:{
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mngId}':{      }
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
        userAssignedIdentity: mngId
      }
      keySource:'Microsoft.Keyvault'
      keyvaultproperties:{
        keyname:'RSAKey'
        keyvaulturi:kvUri
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
      defaultAction:'Deny'
      bypass:'AzureServices'
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

resource stgblob 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01'={
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
    
    publicAccess: 'None'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'upSsh'
  tags:tags
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
output stgName string = sa.name
output storageAccountId string = sa.id
