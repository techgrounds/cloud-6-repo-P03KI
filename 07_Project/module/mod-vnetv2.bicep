targetScope = 'resourceGroup'

//- Import Var
param vnetVar object
param clientVar object
param i int
param tags object

//- Create Public IP's
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' = { 
  name: 'pubIp-${vnetVar.environment[i]}'
  location: clientVar.location
  tags:tags
  sku: {
    name: 'Standard'
    tier:'Regional'
  }
  zones: [
    '1'
    '2'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
//- Create V-Net
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
  }
}
//- Create Subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'subnet${i+1}'
  parent: vnet
  properties: {
    addressPrefix: vnetVar.snet1Prefix[i]
    privateEndpointNetworkPolicies: 'Enabled'
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
