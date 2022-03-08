targetScope = 'subscription'

/////// VARS (defined in 'params.json') ////////
//--- external params
param clientVar object
param vnetVar object
param vmVar object
param dsad string = vmVar.diskSku

//---- deployment booleans test/debug
param deploy object ={
  rg: true
  peer: true

}

//param sshK string = loadTextContent('./etc/SSHKey.pub')
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

//---- secured strings
@secure()
param privIp string
@secure()
param pwdWin string

//---- init-based params
// param recVltName string = 'rv${toLower(uniqueString(subscription().id))}'
 param tenantId string = subscription().tenantId
 param kvName string = '${clientVar.client}-KV-${toLower(uniqueString(subscription().id))}'
// param stgName string = 'storage${toLower(uniqueString(subscription().id))}'

///////////////////// CREATE RESOURCE GROUP ///////////////////////////////////////////////
resource resGr 'Microsoft.Resources/resourceGroups@2021-04-01' = if(deploy.rg){
  name: clientVar.rgName
  location: clientVar.location
  tags:tagsC
}
/////////////////////// VIRTUAL NETWORK ////////////////////////////////////////////////////
//----- Looping vnets
module vNet 'module/mod-vnetv2.bicep' = [for i in range(0, (length(vnetVar.vnetName))) :{
  scope: resGr
  name: 'vNet${i}'
  params: {
    tags:tagsC
    i:i
    clientVar: clientVar
    vnetVar: vnetVar
  }
}]
output x2 string = vNet[1].outputs.subnetId[0]
output x1 string = vNet[0].outputs.subnetId[0]


//------------------- Set up Peering ------------------------------------------------
module vNetPeering 'module/mod-peerv2.bicep' = if(deploy.peer){
  scope: resGr
  name:'vNetPeering' 
  params:{
    vnetVar: vnetVar
    subnetId1: vNet[0].outputs.subnetId[0]
    subnetId2: vNet[1].outputs.subnetId[0]
  }
  dependsOn:[
    vNet
  ]
}

output str string = vNetPeering.outputs.test
// ////////// GET OBJECT ID USER ////////////////
// module objId 'module/mod-psscript.bicep' ={
//   name: 'getObjId'
//   scope: resGr
//   params:{
//     clientVar:clientVar
//   }
// }

///////////  CREATE VNET   ///////////////////
// module vnet './module/mod-vnet.bicep' = {
//   scope: resGr
//   name: '${clientVar.client}-vnet'
//   params:{
//     privIp: privIp
//     tags: tagsC
//     vnetVar: vnetVar
//     clientVar: clientVar
//   }
// }

// /////////// CREATE KEYVAULT //////////////////
// module kv './module/mod-kv.bicep' = {
//   scope: resGr
//   name: kvName
//   params:{
//     tags: tagsC
//     clientVar: clientVar
//     kvVar: kvVar
//     subId1: vnet.outputs.subnetId1
//     subId2: vnet.outputs.subnetId2
//   }
//   dependsOn: [
//     vnet
//   ]
// }
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

