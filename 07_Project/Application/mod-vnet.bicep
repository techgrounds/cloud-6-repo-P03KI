param vnetName array
param vnetPrefix array
param location string
param x int


var vnet1Config = {
  addressSpacePrefix: vnetPrefix[x]
  subnetName: 'subnet1'
  subnetPrefix: vnetPrefix[x]
}

resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName[x]
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

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnetName[x]}-${vnetName[1]}'
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
