///////////////   vars    /////////////////////////////////////////////////////////////

param client string
param vnetName array
param vnetPrefix array
param secretName string
param adminUser string
param vmsize string = 'Standard_A1_v2'
param subnetName array
param vmSku string
param diskSku string
param diskSizeGB int = 50
param location string = resourceGroup().location

//////////////////////  rng defined //////////////////////////////////////////////////////////

param objectId string = subscription().tenantId
param kvName string = 'kv${uniqueString(resourceGroup().id)}'
param stgName string = 'storage${uniqueString(resourceGroup().id)}'
param vm_dns string = 'winssh--${uniqueString(resourceGroup().id)}'

//////////   XXX    ////////////////////////////////////////////////////////////////////////////

@secure()
param secretValue string
param adminPassword string = newGuid()

////////////////////   KV    /////////////////////////////////////////////////////////////////////

module kv 'mod-kv.bicep' = {
  //scope: resourceGroup('test-rg')
  name: kvName
  params: {
    enabledForDeployment: true
    location: location
    keyVaultName: 'kv-${client}'
    objectId: objectId
    secretName: secretName
    secretValue: secretValue
  }
}

//////////////////////   Storage   ///////////////////////////////////////////////////////////////

module stg 'mod-stg.bicep' = {
  //scope: resourceGroup('test-rg')
  name: stgName 
  params:{
    storageAccountName: stgName
    location: location
  }
}

///////////////////////   Netwerk   ////////////////////////////////////////////////////////////////

module vnet 'mod-vnet.bicep' =[for x in range(0, length(vnetName)):{
  name: vnetName[x]
  params:{
    vnetName:vnetName[x]
    vnetPrefix: vnetPrefix[x]
    location: location
    subnetName: subnetName[x]
    x:x
    vm_dns: vm_dns
  }
}]

//_____________________________ VM _________________________________________________________________\\

// module vm 'mod-vm.bicep' = {
//   name: ''
//   params: {
//     adminUser: ''
//     pip: ''
//     publicSshKey: ''
//     vmsize: ''
//   }
//   dependsOn: [
//         ''
//   ]
// }


// output sshhost_connect string = 'ssh ${adminUser}@${PIP.properties.dnsSettings.fqdn}'
