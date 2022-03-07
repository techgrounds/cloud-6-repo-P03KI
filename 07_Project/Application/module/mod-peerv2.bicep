targetScope = 'resourceGroup'

param vnetVar object

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[0]
}
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[1]
}
resource VnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = [for i in range(0, (length(vnetVar.vnetName))) :{
  parent: i == 0 ? vnet : vnet1
  name: i == 0 ? '${vnetVar.vnetName[0]}-${vnetVar.vnetName[1]}':'${vnetVar.vnetName[1]}-${vnetVar.vnetName[0]}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: i == 0 ? vnet1.id : vnet.id
    }
  }
}]
