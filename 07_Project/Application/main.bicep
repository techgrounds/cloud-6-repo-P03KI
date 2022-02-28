//--------------  SET SCOPE  -------------------------------------------------------------------------
targetScope = 'subscription'

//-------------   VARS (defined in 'params.json') -------------------------------------------------------------------------------
param rgName string
param client string = uniqueString(subscription().id)
param vnetName array
param vnetPrefix array
param adminUser string
param vmsize string = 'Standard_A1_v2'
param subnetName array
param vmSku string
param diskSku string
param diskSizeGB int = 50
param location string 
param storageAccountType string
param pubIpName array

@secure()
param pubSSH string

//----------------- Permissions 
@description('all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge')
param keysPermissions array = [
  'all'
]
@description('all, get, list, set, delete, backup, restore, recover, and purge')
param secretsPermissions array = [
  'all'
]
//---------------- MODULE OBJECTS -----------------------------------------------------------------------------------  
param kvObj object ={
  enabledForDiskEncryption: true
  enabledForTemplateDeployment: true
  enabledForDeployment: true
  location: location
  keyVaultName: 'kv-${client}'
  objectId: objectId
  keysPermissions: keysPermissions
  secretsPermissions: secretsPermissions
  pubSSH: pubSSH
}

param vnetObj object = {
  vnetName: vnetName
  vnetPrefix: vnetPrefix
  subnetName: subnetName
  pubIpName: pubIpName
  location: location
}

param vmObj object = {
  adminUser: adminUser
  adminPassword: newGuid()
  vmsize: vmsize
  diskSizeGB: diskSizeGB
  diskSku: diskSku
  location: location
  pubSSH: secretValue

}

//---------------  SET RNG VAR   -----------------------------------------------------------------------
param objectId string = subscription().tenantId
param kvName string = 'kv-${client}'
param stgName string = 'storage${client}'

//---------------   XXX VARS   --------------------------------------------------------------------------------
@secure()
param secretValue string
//param adminPassword string = newGuid()

//----------------- CREATE RESOURCE GROUP ---------------------------------------------------------------
module rg 'mod-rg.bicep' ={
  scope: subscription()
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
    storageAccountType: storageAccountType
    storageAccountName: stgName
    location: location
  }
  dependsOn:[
    rg
  ]
}

//----------------   CREATE KEYVAULT   ----------------------------------------------------------------

module kv 'mod-kv.bicep' = {
  scope: resourceGroup(rgName)
  name: kvName
  params: {
    kvObj: kvObj
  }
  dependsOn:[
    rg
  ]
}

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
    vmObj: vmObj
    //output vars VNET
    pip1: vnet.outputs.pubId1
    //pip2: vnet.outputs.pubId2
    subId1: vnet.outputs.subnetId1
    //subId2:vnet.outputs.subnetId2
  }
}
