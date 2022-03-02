//--------- Import Var -----------------------------------------------------
param vnetObj object

//-------------- Create Public IP's --------------------------------------------
//[for i in range(0, length(vnetObj.pubIpName)):
resource pubIp1 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  'pubIp1'
  location: vnetObj.location
  zones:[
    '1'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
resource pubIp2 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  'pubIp2'
  location: vnetObj.location
  zones:[
    '1'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
//----------------- Create NSG's ------------------------------------------------
resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg1'
  location: vnetObj.location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          description: 'RDP-rule'
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
        name: 'SSH'
        properties: {
          description: 'SSH-rule'
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
      {
        name: 'HTTP'
        properties: {
          description: 'HTTP-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTPS'
        properties: {
          description: 'HTTPS-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
    ]
  }
}
resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg2'
  location: vnetObj.location
  properties: {
    securityRules: [
      {
        name: 'rdp'
        properties: {
          description: 'rdp-rule'
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
          description: 'ssh-rule'
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
      {
        name: 'HTTP'
        properties: {
          description: 'HTTP-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTPS'
        properties: {
          description: 'HTTPS-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
    ]
  }
}

//------------------- Create VNET's ---------------------------------------------
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetObj.vnetName[0]
  location: vnetObj.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetObj.vnetPrefix[0]
      ]
    }
    subnets: [
      {
        name: vnetObj.subnetName[0]
        properties: {
          addressPrefix: vnetObj.vnetPrefix[0]
          networkSecurityGroup: {
            id: nsg1.id
          }
        }  
      }      
    ]
  }
  dependsOn: [
    pubIp1
  ]
}
resource vnet2 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetObj.vnetName[1]
  location: vnetObj.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetObj.vnetPrefix[1]
      ]
    }
    subnets: [
      {
        name: vnetObj.subnetName[1]
        properties: {
          addressPrefix: vnetObj.vnetPrefix[1]
          networkSecurityGroup: {
            id: nsg2.id
          }
        }  
      }      
    ]
  }
  dependsOn: [
    pubIp2
  ]
}

//------------------- Set up Peering ------------------------------------------------
resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: vnet1
  name: '${vnetObj.vnetName[0]}-${vnetObj.vnetName[1]}'
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
resource VnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: vnet2
  name: '${vnetObj.vnetName[1]}-${vnetObj.vnetName[0]}'
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
output pubId1 string = pubIp1.id
output pubId2 string = pubIp2.id
output subnetId1 string = '${vnet1.id}/subnets/${vnetObj.subnetName[0]}'
output subnetId2 string = '${vnet1.id}/subnets/${vnetObj.subnetName[0]}'
