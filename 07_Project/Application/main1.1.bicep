targetScope = 'subscription'

/////// VARS (defined in 'params.json') ////////

//- external params
param clientVar object
param vnetVar object
param vmVar object
param kvVar object = {
  location: clientVar.location
  objectId: iVar.objId
  tenantId: tenantId
  kvName: kvName
}
param tagsC object ={
    Client:clientVar.client
    Version:'1.1'
    DeployDate:utcNow('d')
    Time:utcNow('T')
    Environment: clientVar.deploy
}

//- load pubkey
param sshK string = loadTextContent('./etc/SSHKey.pub')

//- secure params
@secure()
param iVar object
@secure()
param privIp string

//- deployment booleans test/debug
param deploy object ={
  rg: true
  vnet: true
  peer: true
  kv: true
  sa: true
  vm: true
  rv: true
}

//- init-based params
param recVltName string = 'rv${toLower(toLower(uniqueString(utcNow())))}'
param tenantId string = subscription().tenantId
param kvName string = '${clientVar.client}-KV-${toLower(uniqueString(utcNow()))}'
param stgName string = 'sto${toLower(toLower(uniqueString(utcNow())))}'

///////// CREATE RESOURCE GROUP //////////////
resource resGr 'Microsoft.Resources/resourceGroups@2021-04-01' = if(bool(deploy.rg)){
  tags: tagsC
  name: clientVar.rgName
  location: clientVar.location
}

//////////////// V-NET ///////////////////////
module vNet 'module/mod-vnetv2.bicep' = [for (vnetName, i) in vnetVar.vnetName: if(bool(deploy.vnet)){
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

///////////////  PEERING  ////////////////////
module vNetPeering 'module/mod-peerv2.bicep' = if(bool(deploy.peer)) {
  scope: resGr
  name:'vNetPeering' 
  params:{
    vnetId0: vNet[0].outputs.vnetId[0]
    vnetId1: vNet[1].outputs.vnetId[0]
    vnetVar: vnetVar
  }
  dependsOn:[
    vNet
  ]
}

/////////// CREATE KEYVAULT ///////////////////
module kvM './module/mod-kvV2.bicep' = if(bool(deploy.kv)){
  scope: resGr
  name: kvName
  params:{
    pwd: iVar.pwd
    vnetVar: vnetVar
    tags: tagsC
    clientVar: clientVar
    kvVar: kvVar
  }
  dependsOn: [
    vNet
  ]
}

///////////// CREATE STORAGE //////////////////
module stgM './module/mod-stgV2.bicep' = if(bool(deploy.sa)){
  scope: resGr
  name: stgName 
  params:{
    // vnetId0: vNet[0].outputs.vnetId[0]
    // vnetId1: vNet[1].outputs.vnetId[0]
    kvVar: kvVar
    vnetVar: vnetVar
    tags: tagsC
    clientVar: clientVar
    stgType: vmVar.stgType
    stgName: stgName
  }
  dependsOn: [
    kvM
    vNet
  ]
}

/////////////// DEPLOY VM'S ///////////////////
module vm './module/mod-vmV2.bicep' = if(bool(deploy.vm)) {
  scope: resGr
  name: 'vm'
  params:{
    adpw:  iVar.pwd
    kvVar: kvVar
    vnetVar: vnetVar
    tags: tagsC
    clientVar: clientVar
    vmVar: vmVar
    sshK: sshK
  }
  dependsOn:[
    stgM
    vNet
    kvM
  ]
}

////////////////  BACKUP  /////////////////////
module rv './module/mod-rv.bicep' = if(bool(deploy.rv)){
  scope: resGr
  name: recVltName
  params: {
    kvVar: kvVar
    recVltName: recVltName
    tags: tagsC
    clientVar: clientVar
  }
  dependsOn:[
    vm
  ]
}

