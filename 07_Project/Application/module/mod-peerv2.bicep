targetScope = 'resourceGroup'

param vnetVar object
param vnetId0 string 
param vnetId1 string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]

param tempArr array = [
  vnetId1
  vnetId0
]

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
