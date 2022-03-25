targetScope = 'subscription'

/////////////////////////////////////////////////
//////// Techgrounds/Sentia Project 1.1 /////////
/////////////////////////////////////////////////
/////////// Made by: Suheri Koes ////////////////
///////////// Date: 24/03/2022 //////////////////
/////////////////////////////////////////////////

//- external params
param clientVar object
param vnetVar object
param vmVar object
param kvVar object = {
  location: clientVar.location
  objectId: iVar.objId
  tenantId: tenantId
  kvName: iVar.kvName
}
param tags object ={
    Client: clientVar.client
    Version:'1.1'
    DeployDate:utcNow('d')
    Time:utcNow('T')
    Environment: clientVar.deploy
}

//- secure params
@secure()
param iVar object
@secure()
param privIp string

//- deployment booleans test/debug
param extDisk bool = false
param deploy object ={
  vn: true
  pr: true
  kv: true
  sa: true
  ss: true
  vm: true
  rv: false
}

//- init-based params for development with boolean for final deployment
param recVltName string = clientVar.deploy == 'dev' ? 'rv${toLower(uniqueString(utcNow()))}' : 'recvaultxyz24032022'
param tenantId string = subscription().tenantId
param stgName string = clientVar.deploy == 'dev' ? 'sto${toLower(uniqueString(utcNow()))}' : 'storagexyz24032022' 

//- Reference
resource resGr 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: clientVar.rgName
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  scope: resGr
  name: kvVar.kvName
}

//////////////// V-NET ////////////////////////
module vNet 'module/mod-vnetv2.bicep' = [for (vnetName, i) in vnetVar.vnetName: if(bool(deploy.vn)){
  scope: resGr
  name:'VirtualNetwork${i+1}_Deployment'
  params: {
    tags: tags
    clientVar:clientVar
    vnetVar: vnetVar
    i: i
  } 
}]

///////////////  PEERING  /////////////////////
module vNetPeering 'module/mod-peerv2.bicep' = if(bool(deploy.pr)){
  scope: resGr
  name:'Peering_Deployment' 
  params:{
    vnetVar: vnetVar
  }
  dependsOn:[
    vNet
  ]
}

/////////// CREATE KEYVAULT ///////////////////
module kvM './module/mod-kvV2.bicep' = if(bool(deploy.kv)){
  scope: resGr
  name: 'KeyVault_Deployment'
  params:{
    tags: tags
    clientVar: clientVar
    vnetVar: vnetVar
    kvVar: kvVar
  }
  dependsOn: [
    vNet
  ]
}
////////////// CREATE APPGATEWAY //////////////
module appGW 'module/mod-appGW.bicep' = if(bool(deploy.kv)){
  scope: resGr
  name: 'ApplicationGateway_Deployment'
  params:{
    clientVar: clientVar
    tags: tags
    kvVar: kvVar
    vnetVar:vnetVar
  }
  dependsOn:[
    kvM
  ]
}
///////////// CREATE STORAGE //////////////////
module stgM './module/mod-stgV2.bicep' = if(bool(deploy.sa)){
  scope: resGr
  name: 'StorageAccount_Deployment'
  params:{
    extDisk: extDisk
    kvVar: kvVar
    vmVar: vmVar
    vnetVar: vnetVar
    tags: tags
    clientVar: clientVar
    stgType: vmVar.stgType
    stgName: stgName
  }
  dependsOn: [
    kvM
  ]
}

/////////////// DEPLOY VM'S ///////////////////
module vm './module/mod-vmV2.bicep' = if(bool(deploy.vm)){
  scope: resGr
  name: 'AdminServer_Deployment'
  params:{
    privIp: privIp
    adpw:  kv.getSecret('winPW')
    kvVar: kvVar
    vnetVar: vnetVar
    tags: tags
    clientVar: clientVar
    vmVar: vmVar
  }
  dependsOn:[
    stgM
  ]
}

///////////// VM SCALE-SET ///////////////////
module vmss 'module/mod-vmss.bicep' = if (bool(deploy.ss)){
  scope: resGr
  name: 'ScaleSet_Deployment'
    params:{
      kvVar: kvVar
      stgName: stgName
      tags: tags
      vmVar: vmVar
      SSH: kv.getSecret('SSHkey')
      vnetVar: vnetVar
      clientVar: clientVar
    }
    dependsOn:[
      appGW
    ]
}

////////////////  BACKUP  /////////////////////
module rv './module/mod-rv.bicep' = if(bool(deploy.rv)){
  scope: resGr
  name: 'RecoveryVault_Deployment'
  params: {
    kvVar: kvVar
    recVltName: recVltName
    tags: tags
    clientVar: clientVar
  }
  dependsOn:[
    vm
  ]
}
