param vnetName string
param vnetPrefix string
param location string
param subnetName string
param x int
param vm_dns string
param nsgArr array = [
  'nsg.id'
  'nsg2.id'
]

resource PIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'PIP'
  location: location
  tags: {
    displayName: 'PublicIPAddress'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: vm_dns
    }
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'rdp'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'ssh'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: vnetPrefix
          networkSecurityGroup: {
            id: nsgArr[x]
          }
        }  
      }      
    ]
  }
  dependsOn: [
    nsg
    PIP
  ]
}

resource VnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = if(x == 1){
  parent: vnet
  name: vnetName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet.id
    }
  }
}

output pubId string = PIP.id

// resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
//   parent: vnet2
//   name: '${vnetName[1]}-${vnetName[0]}'
//   properties: {
//     allowVirtualNetworkAccess: true
//     allowForwardedTraffic: false
//     allowGatewayTransit: false
//     useRemoteGateways: false
//     remoteVirtualNetwork: {
//       id: vnet1.id
//     }
//   }
// }
// var vnet1Config = {
//   addressSpacePrefix: vnetPrefix[x]
//   subnetName: 'subnet1'
//   subnetPrefix: vnetPrefix[x]
// }
// resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
//   name: vnetName[x]
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         vnet1Config.addressSpacePrefix
//       ]
//     }
//     subnets: [
//       {
//         name: vnet1Config.subnetName
//         properties: {
//           addressPrefix: vnet1Config.subnetPrefix
//         }
//       }
//     ]
//   }
// }

// resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
//   parent: vnet1
//   name: '${vnetName[x]}-${vnetName[1]}'
//   properties: {
//     allowVirtualNetworkAccess: true
//     allowForwardedTraffic: false
//     allowGatewayTransit: false
//     useRemoteGateways: false
//     remoteVirtualNetwork: {
//       id: vnet2.id
//     }
//   }
// }
