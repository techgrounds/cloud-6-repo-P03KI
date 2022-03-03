targetScope = 'subscription'

//-------------   VARS (defined in 'params.json') -------------------------------------------------------------------------------
param clientVar object
param vnetVar object
param vmVar object
param kvVar object = {
  enabledForDiskEncryption: true
  enabledForTemplateDeployment: true
  enabledForDeployment: true
  //vmsize: vmsize
  //vmSku: vmSku
  location: clientVar.location
  keyVaultName: 'kv-${clientVar.client}'
  objectId: clientVar.objId
  certPermissions: certPermissions
  keysPermissions: keysPermissions
  secretsPermissions: secretsPermissions  
  storagePermissions: storagePermissions
  tenantId: tenantId
  kvName: kvName
}
param tenantId string = subscription().tenantId
param unStr string = uniqueString(subscription().id)
param kvName string = 'kv-${clientVar.client}'
param stgName string = '${clientVar.client}storage${unStr}'

//----------------- POLICY PERMISSIONS -----------------------------------------------------------------------
param certPermissions array = [
  'all'
]
param keysPermissions array = [
  'all'
]
param secretsPermissions array = [
  'all' 
]
param storagePermissions array = [
   'all' 
]

//----------------- CREATE RESOURCE GROUP ---------------------------------------------------------------
module rg './module/mod-rg.bicep' = {
  scope:subscription()
  name: clientVar.rgName
  params:{
    rgName: clientVar.rgName
    location: clientVar.location
  }
}

//---------------------  CREATE VNET   -----------------------------------------------------------------------
module vnet './module/mod-vnet.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: '${clientVar.client}-vnet'
  params:{
    vnetVar: vnetVar
  }
  dependsOn: [
    rg
  ]
}

//----------------   CREATE STORAGE --------------------------------------------------------------------
module stg './module/mod-stg.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: stgName 
  params:{
    stgType: vmVar.stgType
    stgName: stgName
    location: clientVar.location
  }
  dependsOn: [
    vnet
  ]
}

//---------------------- CREATE KEYVAULT -------------------------------------------------------------------
module kv './module/mod-kv.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: kvName
  params:{
    kvVar: kvVar
    subId1: vnet.outputs.subnetId1
    subId2: vnet.outputs.subnetId2
  }
  dependsOn: [
    vnet
  ]
}

//----------------------- UPLOAD FILE -------------------------------------------------------------------------
module up './module/mod-up.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: 
  params: {
    clientVar: clientVar
    stNameOutp: stg.outputs
    stKeyOutp: stg.outputs
    cont: loadTextContent('../etc/apache_install.sh')

  }
  dependsOn: [
    stg
  ]
}

//---------------------  DEPLOY VM'S  ------------------------------------------------------------------
module vm './module/mod-vm.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: 'vm'
  params:{
    //kvObj:kvObj
    vmVar: vmVar
    pip1: vnet.outputs.pubId1
    pip2: vnet.outputs.pubId2
    subId1: vnet.outputs.subnetId1
    subId2: vnet.outputs.subnetId2
  }
  dependsOn:[
    vnet
    kv
  ]
}
