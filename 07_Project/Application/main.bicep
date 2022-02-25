//targetScope = 'subscription'

//________________vars_____________________________________________

param location string
param client string
param vnetName array
param vnetPrefix array
param secretName string
param adminUser string
param publicSshKey string
param vmsize string = 'Standard_A1_v2'

//_____________ rng defined ____________________________________

param objectId string = subscription().tenantId
param kvName string = 'kv-${client}-${uniqueString(resourceGroup().id)}'
param stgName string = 'storage${uniqueString(resourceGroup().id)}'

//___________ xxx ____________________________

@secure()
param secretValue string

//_________________________________KV_____________________________________________________

module kv 'mod-kv.bicep' = {
  //scope: resourceGroup('test-rg')
  name: kvName
  params: {
    location: location
    keyVaultName: 'kv-${client}'
    objectId: objectId
    secretName: secretName
    secretValue: secretValue
  }
}
output kvName string = '${kvName}_deployed' 

// ______________________________Storage________________________________________________

module stg 'mod-stg.bicep' = {
  //scope: resourceGroup('test-rg')
  name: stgName 
  params:{
    storageAccountName: stgName
    location: location
  }
}


// ________________________________ VNET _______________________________________________
//
// module vnet 'mod-vnet.bicep' =[for x in range(length(0, vnetName)):{
//   name: vnetName[x]
//   params:{
//   }
// }]

var vnet1Config = {
  addressSpacePrefix: vnetPrefix[0]
  subnetName: 'subnet1'
  subnetPrefix: vnetPrefix[0]
}
var vnet2Config = {
  addressSpacePrefix: vnetPrefix[1]
  subnetName: 'subnet1'
  subnetPrefix: vnetPrefix[1]
}
resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName[0]
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet1Config.subnetName
        properties: {
          addressPrefix: vnet1Config.subnetPrefix
         }
      }
    ]
  }
}
resource vnet2 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName[1]
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet2Config.subnetName
        properties: {
          addressPrefix: vnet2Config.subnetPrefix
        }
      }
    ]
  }
}
output state2 string = 'vnets_deployed' 
resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnetName[0]}-${vnetName[1]}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}
resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet2
  name: '${vnetName[1]}-${vnetName[0]}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
output state3 string = 'peering_deployed' 

//_____________________________ VM _______________________________________

module vm 'mod-vm.bicep' = {
  name: stgName
  params:{
    location: location
    storagename: stgName
    adminUser: adminUser
    vmsize: vmsize
    publicSshKey: publicSshKey
  }
}
