//--------- Import Var -----------------------------------------------------
param vnetArr object

//-------------- Create Public IP's --------------------------------------------
//[for i in range(0, length(vnetArr.pubIpName)):
resource pubIp1 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  string(vnetArr.vnetName[0]) 
  location: vnetArr.location
  tags: {
    displayName: 'PublicIPAddress1'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: vnetArr.vm_dns
    }
  }
}
resource pubIp2 'Microsoft.Network/publicIPAddresses@2021-05-01' =  { 
  name:  string(vnetArr.vnetName[1]) 
  location: vnetArr.location
  tags: {
    displayName: 'PublicIPAddress2'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: vnetArr.vm_dns
    }
  }
}
//----------------- Create NSG's ------------------------------------------------
resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg1'
  location: vnetArr.location
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
    ]
  }
}
resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg2'
  location: vnetArr.location
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
    ]
  }
}

//------------------- Create VNET's ---------------------------------------------
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetArr.vnetName[0]
  location: vnetArr.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetArr.vnetPrefix[0]
      ]
    }
    subnets: [
      {
        name: vnetArr.subnetName
        properties: {
          addressPrefix: vnetArr.vnetPrefix[0]
          networkSecurityGroup: {
            id: nsgArr[0]
          }
        }  
      }      
    ]
  }
  dependsOn: [
    nsg1
    pubIp1
  ]
}
resource vnet2 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetArr.vnetName[1]
  location: vnetArr.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetArr.vnetPrefix[0]
      ]
    }
    subnets: [
      {
        name: vnetArr.subnetName
        properties: {
          addressPrefix: vnetArr.vnetPrefix[0]
          networkSecurityGroup: {
            id: nsgArr[0]
          }
        }  
      }      
    ]
  }
  dependsOn: [
    nsg2
    pubIp2
  ]
}

//------------------- Set up Peering ------------------------------------------------
resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  parent: vnet1
  name: '${vnetArr.vnetName[0]}-${vnetArr.vnetName[1]}'
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
  parent: vnet2
  name: '${vnetArr.vnetName[1]}-${vnetArr.vnetName[0]}'
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
output pubId1 string = pubIp1.id
output pubId2 string = pubIp2.id
