targetScope = 'resourceGroup'
//param clientVar object
param vnetVar object

resource vnet0 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[0]
}
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[1]
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: vnet0
  name: '${vnetVar.vnetName[0]}-${vnetVar.vnetName[1]}'
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
resource VnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: vnet1
  name: '${vnetVar.vnetName[1]}-${vnetVar.vnetName[0]}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet0.id
    }
  }
}

// resource VnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = [for i in range(0, (length(vnetVar.vnetName))) :{
//   parent: i == 0 ? vnet0 : vnet1
//   name: i == 0 ? '${vnetVar.vnetName[0]}-${vnetVar.vnetName[1]}' : '${vnetVar.vnetName[1]}-${vnetVar.vnetName[0]}'
//   properties: {
//     allowVirtualNetworkAccess: true
//     allowForwardedTraffic: false
//     allowGatewayTransit: false
//     useRemoteGateways: false
//     remoteVirtualNetwork: {
//       id: i == 0 ? vnet1.id : vnet0.id
//     }
//   }
// }]
