targetScope = 'subscription'

///////////////////////  OBJVARS (defined in 'params.json') //////////////////////////////////////////////
param clientVar object
param vnetVar object
//param vnetOut object
param vmVar object
param sshK string = loadTextContent('./etc/SSHKey.pub')
param kvVar object ={
  enabledForDiskEncryption: true
  enabledForTemplateDeployment: true
  enabledForDeployment: true
  location: clientVar.location
  keyVaultName: 'kv-${clientVar.client}'
  objectId: clientVar.objId
  tenantId: tenantId
  kvName: kvName
}
//----------- Secure strings --------------------------------------
@secure()
param pwdWin string
//----------- Init-based strings ---------------------------------
param subscrId string = subscription().id
param tenantId string = subscription().tenantId
param unStr string = uniqueString(subscription().id)
param kvName string = '${clientVar.client}-KV-${unStr}'
param stgName string = '${toLower(clientVar.client)}storage${unStr}'

/////////////////////// RESOURCE GROUP ////////////////////////////////////////////////////////////////////
//--- Setting up a RG
resource ResGr 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: clientVar.rgName
  location: clientVar.location
}

/////////////////////// VIRTUAL NETWORK ////////////////////////////////////////////////////
//----- Looping vnets
module vNet 'module/mod-vnetv2.bicep' = [for i in range(0, (length(vnetVar.vnetName))) :{
  scope: resourceGroup(clientVar.rgName)
  name: 'vNet'
  params: {
    i:i
    clientVar: clientVar
    vnetVar: vnetVar
  }
  dependsOn:[
    ResGr
  ]
}]
//------------------- Set up Peering ------------------------------------------------
module vNetPeering 'module/mod-peer.bicep' ={
  scope: resourceGroup(clientVar.rgName)
  name:'vNetPeering' 
  params:{
    vnetVar: vnetVar
  }
  dependsOn:[
    vNet
  ]
}

//////////////////////// KEYVAULT /////////////////////////////////////////////
module kVault 'module/mod-kv.bicep' ={
  scope: resourceGroup(clientVar.rgName)
  name: kvName
  params:{
    kvVar: kvVar
    subId2: vNet[1].outputs.subnetId[1]
    subId1: vNet[0].outputs.subnetId[0]
    clientVar: clientVar
  }
  dependsOn:[
    vNetPeering
    vNet
  ]
}
// resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
//   name: kvVar.kvName
//   location: kvVar.location
//   properties:{
//     enabledForDeployment: true
//     enabledForDiskEncryption: true
//     enabledForTemplateDeployment: true
//     enableRbacAuthorization: false
//     tenantId:  kvVar.tenantId
//     ////////// Temporary for testdeployments ///////////////////////
//     enableSoftDelete: false
//     //////////////////////////////////////////////////////////////
//     accessPolicies:[
//       {
//         objectId: kvVar.objectId
//         tenantId: kvVar.tenantId
//         permissions:{
//           keys:[
//             'all'
//           ]
//           secrets:[
//             'all'
//           ]
//           storage:[
//             'all'
//           ]
//           certificates:[
//             'all'
//           ]
//         }
//       }
//     ]
//     sku:{
//       name: 'standard'
//       family: 'A'
//     }
//     networkAcls: {
//       defaultAction: 'Deny'
//       bypass: 'AzureServices'
//       virtualNetworkRules:[
//         {
//             id: subId1

//         }       
//         {
//             id: subId2        
//         }
//     ]
//     }
//   }
// }
// resource kvPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-10-01'= {
//   name: 'add'
//   parent: kv
//   properties:{
//     accessPolicies:[
//       {
//         applicationId: RSAKey.id
//         tenantId: kvVar.tenantId
//         objectId: kvVar.objectId
//         permissions:{
//           keys:[
//             'all'
//           ]
//           storage:[
//             'all'
//           ]
//         }   
//       }
//       {
//         applicationId: dskEncrKey.id
//         tenantId: kvVar.tenantId
//         objectId: kvVar.objectId
//         permissions:{
//           keys:[
//             'all'
//           ]
//           storage:[
//             'all'
//           ]
//         }
        
//       }
//       {
//         applicationId: mngId.id
//         tenantId: kvVar.tenantId
//         objectId: kvVar.objectId
//         permissions: {
//           keys: [
//            'all'
//           ]
//           storage: [
//             'all'
//           ]
//           secrets: [
//             'all'
//           ]
//         }    
//       }
//     ]
//   }
// }
// resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: clientVar.client
//   location: clientVar.location
//   dependsOn: [
//     kv
//   ]
// }
// //--------------------- Create Keys ------------------------------------------
// resource secret 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
//   parent: kv
//   name: 'ssh'
//   properties: {
//     value: loadTextContent('../etc/SSHKey.pub')
//   }
// }
// resource RSAKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' = {
//   name: 'RSAKey'
//   parent: kv
//   properties:{
//     kty: 'RSA'
//     keySize: 4096
//     keyOps:[
//       'unwrapKey'
//       'wrapKey'
//       'decrypt'
//       'encrypt'
//       'verify'
//       'sign'
//     ]
//     attributes:{
//       enabled:true
//     }
//   }
// }
// resource dskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
//   name: 'dskEncrKey-${clientVar.client}'
//   location: clientVar.location
//   identity: {
//     type: 'SystemAssigned'
//   }
//   properties: {
//     rotationToLatestKeyVersionEnabled:true
//     activeKey: {
//       keyUrl: RSAKey.properties.keyUriWithVersion
//       sourceVault: {
//         id: kv.id
//       }
//     }
//     encryptionType: 'EncryptionAtRestWithCustomerKey'
//   }
  
// }
// ////////////////////////// STORAGE //////////////////////////////////////////
// resource sa 'Microsoft.Storage/storageAccounts@2021-08-01'={
//   name:stgName
//   location:clientVar.location
//   sku: {
//     name: stgType
//   }
//   kind:'StorageV2'
//   properties:{
//     accessTier:'Cool'
//     allowSharedKeyAccess:true
//     encryption:{
//       keySource:'Microsoft.Keyvault'
//       keyvaultproperties:{
//         keyname:'RSAKey'
//         keyvaulturi:kvUri
//       }
//       services:{
//         blob:{
//           enabled:true
//           keyType:'Account'
//         }
//         file:{
//           enabled:true
//           keyType:'Account'
//         }
//         queue:{
//           enabled:true
//           keyType:'Account'
//         }
//         table:{
//           enabled:true
//           keyType:'Account'
//         }
//       }
//     }
//     networkAcls:{
//       defaultAction:'Allow'
//       bypass:'AzureServices'
//       virtualNetworkRules:[
//         {
//             id: subId1
//         }       
//         {
//             id: subId2
//         }
//       ]
//     }
//   }
// }
// resource stgblob 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01'={
//   parent: sa
//   name: 'default'
//   properties:{
//     containerDeleteRetentionPolicy:{
//       enabled: true
//       days: 30
//     }
//     deleteRetentionPolicy:{
//       enabled: true
//       days: 30
//     }
//     automaticSnapshotPolicyEnabled:true
//     isVersioningEnabled: true
//     restorePolicy:{
//       enabled: true
//       days:7
//     }
//     changeFeed: {
//       enabled: true
//       retentionInDays: 14
//     }
//   }
// }
// resource stgblobcnt 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01'={
//   parent: stgblob
//   name: 'bootstrapdata'
//   properties: {
//     publicAccess: 'None'
//   }
// }
// ///////////////////////// VM's ///////////////////////////////////////////////
// module vm './module/mod-vm.bicep' = {
//   scope: resourceGroup(clientVar.rgName)
//   name: 'vm'
//   params:{
//     clientVar: clientVar
//     vmVar: vmVar
//     sshK: sshK
//     pip1: vnet.outputs.pubId1
//     pip2: vnet.outputs.pubId2
//     subId1: vnet.outputs.subnetId1
//     subId2: vnet.outputs.subnetId2
//     //kvUri: kv.outputs.kvUri
//     pwdWin: pwdWin
//   }
//   dependsOn:[
//     vnet
//     kv
//   ]
// }

///////////////////// BACKUP ////////////////////////////////////////////////
