targetScope = 'subscription'

/////// VARS (defined in 'params.json') ////////
param clientVar object
param vnetVar object
param vmVar object
param sshK string = loadTextContent('./etc/SSHKey.pub')
param kvVar object = {
  location: clientVar.location
  objectId: clientVar.objId
  tenantId: tenantId
  kvName: kvName
}
@secure()
param pwdWin string
// ----- init based strings
param tenantId string = subscription().tenantId
param unStr string = uniqueString(subscription().id)
param kvName string = '${clientVar.client}-KV-${utcNow()}'
param stgName string = '${toLower(clientVar.client)}storage${unStr}'

/////////// CREATE RESOURCE GROUP ////////////
module rg './module/mod-rg.bicep' = {
  scope:subscription()
  name: clientVar.rgName
  params:{
    clientVar: clientVar
  }
}
///////////  CREATE VNET   ///////////////////
module vnet './module/mod-vnet.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: '${clientVar.client}-vnet'
  params:{
    vnetVar: vnetVar
    clientVar: clientVar
  }
  dependsOn: [
    rg
  ]
}
/////////// CREATE KEYVAULT //////////////////
module kv './module/mod-kv.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: kvName
  params:{
    clientVar: clientVar
    kvVar: kvVar
    subId1: vnet.outputs.subnetId1
    subId2: vnet.outputs.subnetId2
  }
  dependsOn: [
    vnet
  ]
}
///////////// CREATE STORAGE //////////////////
module stg './module/mod-stg.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: stgName 
  params:{
    mngId: kv.outputs.mngId
    clientVar: clientVar
    stgType: vmVar.stgType
    stgName: stgName
    subId1: vnet.outputs.subnetId1
    subId2: vnet.outputs.subnetId2
    kvUri: kv.outputs.kvUri
  }
  dependsOn: [
    kv
    vnet
  ]
}
//////////// DEPLOY VM'S ////////////////
module vm './module/mod-vm.bicep' = {
  scope: resourceGroup(clientVar.rgName)
  name: 'vm'
  params:{
    dskEncrKey: kv.outputs.dskEncrId
    clientVar: clientVar
    vmVar: vmVar
    sshK: sshK
    pip1: vnet.outputs.pubId1
    pip2: vnet.outputs.pubId2
    subId1: vnet.outputs.subnetId1
    subId2: vnet.outputs.subnetId2
    pwdWin: pwdWin
  }
  dependsOn:[
    stg
    vnet
    kv
  ]
}
/////////  Set up Recovery Vault ////////////
// module rv './module/mod-rv.bicep' = {
//   name: 'Recovery Vault'
//   scope: resourceGroup(clientVar.rgName)
//   params: {
//     clientVar: clientVar
//     webVmId: vm.outputs.webVmId
//   }
//   dependsOn:[
//     vm
//   ]
// }

