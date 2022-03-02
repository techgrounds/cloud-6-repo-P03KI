targetScope = 'subscription'

//-------------   VARS (defined in 'params.json') -------------------------------------------------------------------------------
param rgName string
param vnetName array
param vnetPrefix array
param adminUser string
param vmsize string
param subnetName array
param vmSku string
param diskSku string
param diskSizeGB int
param location string 
param stgType string
param pubIpName array
param tenantId string = subscription().tenantId
@secure()
param pubSSH string
@secure()
param adminPassword string
param client string = uniqueString(subscription().id)

//----------------- Permissions 
@description('all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge')
param keysPermissions array = [
  'all'
  'encrypt'
  'decrypt'
  'wrapkey'
  'unwrapkey'
  'get'
  'create'
  'import'
  'verify'
]
@description('all, get, list, set, delete, backup, restore, recover, and purge')
param secretsPermissions array = [
  'all' 
  'get'
  'list'
  'set'
  'backup'
//--- test deployment only -----
  'purge'
]

//---------------  SET RNG VAR   -----------------------------------------------------------------------
param objectId string = subscription().tenantId
param kvName string = 'kv-${client}'
param stgName string = 'storage${client}'

//---------------- MODULE OBJECTS -----------------------------------------------------------------------------------  
param kvObj object = {
  enabledForDiskEncryption: true
  enabledForTemplateDeployment: true
  enabledForDeployment: true
  vmsize: vmsize
  vmSku: vmSku
  location: location
  keyVaultName: 'kv-${client}'
  objectId: objectId
  keysPermissions: keysPermissions
  secretsPermissions: secretsPermissions
  pubSSH: pubSSH
  tenantId: tenantId
  kvName: kvName

}
param vnetObj object = {
  vnetName: vnetName
  vnetPrefix: vnetPrefix
  subnetName: subnetName
  pubIpName: pubIpName
  location: location
}
param vmObj object = {
  vmSku: vmSku
  adminUser: adminUser
  adminPassword: adminPassword
  vmsize: vmsize
  diskSizeGB: diskSizeGB
  diskSku: diskSku
  location: location
  client: client
}

//----------------- CREATE RESOURCE GROUP ---------------------------------------------------------------
module rg 'mod-rg.bicep' = {
  scope:subscription()
  name: rgName
  params:{
    rgName: rgName
    location: location
  }
}
  
//----------------   CREATE STORAGE --------------------------------------------------------------------
module stg 'mod-stg.bicep' = {
  scope: resourceGroup(rgName)
  name: stgName 
  params:{
    stgType: stgType
    stgName: stgName
    location: location
  }
  dependsOn: [
    rg
  ]
}

//----------------   CREATE KEYVAULT   ----------------------------------------------------------------
// module kv 'mod-kv.bicep' = {
//   scope: resourceGroup
//   name: kvName
//   params: {
//     kvObj: kvObj
//   }
// }

//---------------------  Netwerk   -----------------------------------------------------------------------
module vnet 'mod-vnet.bicep' = {
  scope: resourceGroup(rgName)
  name: vnetObj.vnetName[0]
  params:{
    vnetObj: vnetObj
  }
  dependsOn: [
    rg
  ]
}

//---------------------  VM's ------------------------------------------------------------------
module vm 'mod-vm.bicep' = {
  scope: resourceGroup(rgName)
  name: 'vm'
  params:{
    //kvObject: 
    kvObj: kvObj
    vmObj: vmObj
    //------ output VNET -------------------------------
    pip1: vnet.outputs.pubId1
    //pip2: vnet.outputs.pubId2
    subId1: vnet.outputs.subnetId1
    //subId2:vnet.outputs.subnetId2
  }
  dependsOn:[
    vnet
  ]
}
