targetScope = 'subscription'

/////// VARS (defined in 'params.json') ////////

//- external params
param clientVar object
param vnetVar object
param vmVar object
param kvVar object = {
  location: clientVar.location
  objectId: clientVar.objId
  tenantId: tenantId
  kvName: kvName
}
param tagsC object ={
    Client:clientVar.client
    Version:'1.1'
    DeployDate:utcNow('d')
    Time:utcNow('T')
}
//- load pubkey
param sshK string = loadTextContent('./etc/SSHKey.pub')

//- secured strings
@secure()
param privIp string
@secure()
param pwdWin string

//- deployment booleans test/debug
param deploy object ={
  rg: false
  vnet: false
  peer: false
  scr: true
  kv: false
}

//- init-based params
// param recVltName string = 'rv${toLower(uniqueString(subscription().id))}'
param tenantId string = subscription().tenantId
param kvName string = '${clientVar.client}-KV-${toLower(uniqueString(subscription().id))}'
param stgName string = 'storage${toLower(uniqueString(subscription().id))}'

///////////////////// CREATE RESOURCE GROUP ///////////////////////////////////////////////

resource resGr 'Microsoft.Resources/resourceGroups@2021-04-01' = if(bool(deploy.rg)){
  tags: tagsC
  name: clientVar.rgName
  location: clientVar.location
}
/////////////////////// V-NET ////////////////////////////////////////////////////

//- Looping vnets
module vNet 'module/mod-vnetv2.bicep' = [for i in range(0, (length(vnetVar.vnetName))) : if(bool(deploy.vnet)){
  scope: resGr
  name:'${clientVar.client}-vNet${i}'
  params: {
    tags: tagsC
    clientVar:clientVar
    vnetVar: vnetVar
    privIp: privIp
    i: i
  }
}]

//- Set peering
module vNetPeering 'module/mod-peerv2.bicep' = if(bool(deploy.peer)) {
  scope: resGr
  name:'vNetPeering' 
  params:{
    vnetVar: vnetVar
  }
  dependsOn:[
    vNet
  ]
}

//- Run PS cmd -> ObjId Workaround
module objId 'module/mod-psscript.bicep' = if(bool(deploy.scr)){
  name:'getObjId'
  scope: resGr
  params:{
    vnetVar: vnetVar
    stgName: stgName
    stgType: vmVar.stgType
    clientVar: clientVar
    tags: tagsC
  }
}
//output test string = objId.outputs.testScr
output objId string = objId.outputs.objId

/////////// CREATE KEYVAULT //////////////////
module kv './module/mod-kvV2.bicep' = if(bool(deploy.kv)){
  scope: resGr
  name: kvName
  params:{
    sshK: sshK
    vnetVar: vnetVar
    tags: tagsC
    clientVar: clientVar
    kvVar: kvVar
  }
  dependsOn: [
    vNet
  ]
}


// ///////////// CREATE STORAGE //////////////////
// module stg './module/mod-stg.bicep' = {
//   scope: resGr
//   name: stgName 
//   params:{
//     tags: tagsC
//     mngId: kv.outputs.mngId
//     clientVar: clientVar
//     stgType: vmVar.stgType
//     stgName: stgName
//     subId1: vnet.outputs.subnetId1
//     subId2: vnet.outputs.subnetId2
//     kvUri: kv.outputs.kvUri
//   }
//   dependsOn: [
//     kv
//     vnet
//   ]
// }
// //////////// LOADBALANCER ///////////////
// module lb 'module/mod-lb.bicep' = {
//   scope: resGr
//   name: 'loadbalancer'
//   params:{
//     clientVar: clientVar
//     tags:tagsC



//   }
// }

// //////////// DEPLOY VM'S ////////////////
// module vm './module/mod-vm.bicep' = {
//   scope: resGr
//   name: 'vm'
//   params:{
//     tags: tagsC
//     dskEncrKey: kv.outputs.dskEncrId
//     clientVar: clientVar
//     vmVar: vmVar
//     sshK: sshK
//     pip1: vnet.outputs.pubId1
//     pip2: vnet.outputs.pubId2
//     subId1: vnet.outputs.subnetId1
//     subId2: vnet.outputs.subnetId2
//     pwdWin: pwdWin
//   }
//   dependsOn:[
//     stg
//     vnet
//     kv
//   ]
// }
// /////////////  BACKUP  ////////////////////
// module rv './module/mod-rv.bicep' = {
//   scope: resGr
//   name: recVltName
//   params: {
//     recVltName: recVltName
//     //mngName: kv.outputs.mngName
//     admSrvName: vm.outputs.admSrvName
//     webSrvName: vm.outputs.webSrvName
//     tags: tagsC
//     //kvUri: kv.outputs.kvUri
//     clientVar: clientVar
//     webVmId: vm.outputs.webVmId
//     admVmId: vm.outputs.admVmId
//   }
//   dependsOn:[
//     vm
//   ]
// }

