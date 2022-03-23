targetScope = 'resourceGroup'

param vnetVar object

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]

var tempArr = [
  vnet[1].id
  vnet[0].id
]


//- TO-DO PRIO_5: via ref of output(string + i).
//- complexere functie voor outscaling vnet en peering 
resource vNetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = [for (vnetName, i) in vnetVar.vnetName: {
  name: '${vnetVar.vnetName[i]}-peering'
  parent: vnet[i]
  properties: {
        allowVirtualNetworkAccess: true
        allowForwardedTraffic: false
        allowGatewayTransit: false
        useRemoteGateways: false
        remoteVirtualNetwork: {
          id: tempArr[i]
        }
      }
}]
