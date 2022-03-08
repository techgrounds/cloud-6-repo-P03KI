targetScope = 'resourceGroup'
//--------- Import Var -----------------------------------------------------
param vnetVar object
param clientVar object
param i int
param tags object

//-------------- Create Public IP's --------------------------------------------

resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' = { 
  name:'pubIp${i+1}'
  location: clientVar.location
  tags:tags
  zones: [
    '1'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

//----------------- Create NSG's ------------------------------------------------
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: string('nsg${i+1}')
  location: clientVar.location
  tags:tags
  properties: i == 0 ? {
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
          priority: 100
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
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }:{
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
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetVar.vnetName[i]
  location: clientVar.location
  tags:tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetVar.vnetPrefix[i]
      ]
    }
    subnets: [
      {
        name: 'subnet${i+1}'
        properties: {
          addressPrefix: vnetVar.vnetPrefix[i]
          networkSecurityGroup: {
            id: nsg.id
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
}

//----------- Output -------------------------
// output vnetOut object = {
//   vnetId: [
//     vnet.id
//   ]
//   pubIpId: [
//     pubIp.id
//   ]
//   subnetId: [
//     '${vnet.id}/subnets/subnet${i}'
//   ]
// }
output vnetId array = [
  vnet.id
] 
output pubIpId array = [
  pubIp.id
]
output subnetId array = [
  '${vnet.id}/subnets/subnet${i}'
]




