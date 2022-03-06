//--------- Import Var -----------------------------------------------------
param vnetVar object
param clientVar object
//-------------- Create Public IP's --------------------------------------------
//[for i in range(0, length(vnVar.pubIpName)):
resource pubIp1 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  'pubIp1'
  location: clientVar.location
  zones:[
    '1'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
resource pubIp2 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  'pubIp2'
  location: clientVar.location
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
  location: clientVar.location
  properties: {
    securityRules: [
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
  location: clientVar.location
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
          access: 'Allow'
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
      
    ]
  }
}

//------------------- Create VNET's ---------------------------------------------
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetVar.vnetName[0]
  location: clientVar.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetVar.vnetPrefix[0]
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: vnetVar.vnetPrefix[0]
          networkSecurityGroup: {
            id: nsg1.id
          }
          serviceEndpoints: [
            { 
              service: 'Microsoft.KeyVault'
            }
            {  
              service: 'Microsoft.Storage'
            }
          ]
        }         
      }      
    ]
  }
  
  dependsOn: [
    pubIp1
  ]

}
resource vnet2 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetVar.vnetName[1]
  location: clientVar.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetVar.vnetPrefix[1]
      ]
    }
    subnets: [
      {
        name: 'subnet2'
        properties: {
          addressPrefix: vnetVar.vnetPrefix[1]
          networkSecurityGroup: {
            id: nsg2.id
          }
          serviceEndpoints: [
            { 
              service: 'Microsoft.KeyVault'
            }
            {  
              service: 'Microsoft.Storage'
            }
          ]
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
  name: '${vnetVar.vnetName[0]}-${vnetVar.vnetName[1]}'
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
  name: '${vnetVar.vnetName[1]}-${vnetVar.vnetName[0]}'
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
output subnetId1 string = '${vnet1.id}/subnets/subnet1'
output subnetId2 string = '${vnet2.id}/subnets/subnet2'


