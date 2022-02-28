//--------------  SET SCOPE  -------------------------------------------------------------------------
targetScope = 'subscription'

//-------------   VARS (defined in 'params.json') -------------------------------------------------------------------------------
param rgName string
param client string = uniqueString(subscription().id)
param vnetName array
param vnetPrefix array
param secretName string
param adminUser string
param vmsize string = 'Standard_A1_v2'
param subnetName array
param vmSku string
param diskSku string
param diskSizeGB int = 50
param location string 
param storageAccountType string
param pubIpName array
//param vm_dns string 

//---------------- OBJECTS -----------------------------------------------------------------------------------  
param vnetArr object = {
  vnetName: vnetName
  vnetPrefix: vnetPrefix
  subnetName: subnetName
  pubIpName: pubIpName
  vm_dns: 'winssh--${client}'
  location: location
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
    enabledForDeployment: true
    location: location
    keyVaultName: 'kv-${client}'
    objectId: objectId
    secretName: 'secretName'
    secretValue: 'secretValue'
  }
  dependsOn:[
    rg
  ]
}

//---------------------  Netwerk   -----------------------------------------------------------------------
module vnet 'mod-vnet.bicep' = {
  scope: resourceGroup(rgName)
  name: vnetArr.vnetName[0]
  params:{
    vnetArr: vnetArr
  }
  dependsOn: [
    rg
]
}
