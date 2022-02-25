param vnetName string
param vnetPrefix string
//param subnets string
param location string
param subnetName string


// // https://docs.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks?tabs=bicep

resource symbolicname 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  tags: {
    Type: 'vnet'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
         vnetPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: [
        'string'
      ]
    }
    enableDdosProtection: false
    enableVmProtection: true
    encryption: {
      enabled: true
      enforcement: 'string'
    }
  
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: vnetPrefix
          addressPrefixes: [
            'string'
          ]

          networkSecurityGroup: {
            id: 'string'
            location: 'string'
            properties: {
              securityRules: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    access: 'Allow'
                    description: 'string'
                    destinationAddressPrefix: 'string'
                    destinationAddressPrefixes: [
                      'string'
                    ]
                    destinationApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    destinationPortRange: 'string'
                    destinationPortRanges: [
                      'string'
                    ]
                    direction: 'string'
                    //priority: int
                    protocol: 'string'
                    sourceAddressPrefix: 'string'
                    sourceAddressPrefixes: [
                      'string'
                    ]
                    sourceApplicationSecurityGroups: [
                      {
                        id: 'string'
                        location: 'string'
                        properties: {}
                        tags: {}
                      }
                    ]
                    sourcePortRange: 'string'
                    sourcePortRanges: [
                      'string'
                    ]
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          privateEndpointNetworkPolicies: 'string'
          privateLinkServiceNetworkPolicies: 'string'
          routeTable: {
            id: 'string'
            location: 'string'
            properties: {
              //disableBgpRoutePropagation: bool
              routes: [
                {
                  id: 'string'
                  name: 'string'
                  properties: {
                    addressPrefix: 'string'
                    //hasBgpOverride: bool
                    nextHopIpAddress: 'string'
                    nextHopType: 'string'
                  }
                  type: 'string'
                }
              ]
            }
            tags: {}
          }
          serviceEndpointPolicies: [
            {
              id: 'string'
              location: 'string'
              properties: {
                contextualServiceEndpointPolicies: [
                  'string'
                ]
                serviceAlias: 'string'
                serviceEndpointPolicyDefinitions: [
                  {
                    id: 'string'
                    name: 'string'
                    properties: {
                      description: 'string'
                      service: 'string'
                      serviceResources: [
                        'string'
                      ]
                    }
                    type: 'string'
                  }
                ]
              }
              tags: {}
            }
          ]
          serviceEndpoints: [
            {
              locations: [
                'string'
              ]
              service: 'string'
            }
          ]
        }
        type: 'string'
      }
    ]
    virtualNetworkPeerings: [
      {
        id: 'string'
        name: 'string'
        properties: {
          //allowForwardedTraffic: bool
          //allowGatewayTransit: bool
          allowVirtualNetworkAccess: true
          doNotVerifyRemoteGateways: false
          peeringState: 'string'
          peeringSyncLevel: 'string'
          remoteAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          remoteBgpCommunities: {
            virtualNetworkCommunity: 'string'
          }
          remoteVirtualNetwork: {
            id: 'string'
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              'string'
            ]
          }
          useRemoteGateways: false
        }
        type: 'string'
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-04-01' = {
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

// resource vnetDpl 'Microsoft.Network/virtualNetworks@2021-05-01' ={
//   name: vnetName
// }

// resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
//   name: vnetName
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: vnetPrefix
//     }
//     subnets:  [
//       {
//         subnetName: subnetName[0]
//         properties: {
//           addressPrefix: int(vnetPrefix[0])
//         }
//       } 
//     ]
//   }
// }

//output id string = vnet.id
