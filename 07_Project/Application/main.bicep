//targetScope = 'subscription'

//_____vars____________________________________________________________________________________

param client string
param vnetName array
param vnetPrefix array
param secretName string
param adminUser string
//param publicSshKey string
param vmsize string = 'Standard_A1_v2'
param subnetName array
@allowed([
  '2019-datacenter-core-g2'
  '2019-datacenter-core-smalldisk-g2'
  '2022-datacenter-core-g2'
  '2022-datacenter-core-smalldisk-g2'
  '2022-datacenter-azure-edition-core'
  '2022-datacenter-azure-edition-core-smalldisk'
])
param vmSku string = '2022-datacenter-core-smalldisk-g2'
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param diskSku string = 'StandardSSD_LRS'
param diskSizeGB int = 50
param location string = resourceGroup().location

//_____________ rng defined __________________________________________________________________

param objectId string = subscription().tenantId
param kvName string = 'kv-${client}-${uniqueString(resourceGroup().id)}'
param stgName string = 'storage-${uniqueString(resourceGroup().id)}'
param vm_dns string = 'winssh-${uniqueString(resourceGroup().id)}'
//param _artifactsLocation string = deployment().properties.templateLink.uri

//________ xxx ________________________________________________________________________________

@secure()
param secretValue string
param adminPassword string = newGuid()
//param _artifactsLocationSasToken string = ''

//__________ KV _______________________________________________________________________________

module kv 'mod-kv.bicep' = {
  //scope: resourceGroup('test-rg')
  name: kvName
  params: {
    location: location
    keyVaultName: 'kv-${client}'
    objectId: objectId
    secretName: secretName
    secretValue: secretValue
  }
}
output kvName string = '${kvName}_deployed' 

// __________ Storage ___________

module stg 'mod-stg.bicep' = {
  //scope: resourceGroup('test-rg')
  name: stgName 
  params:{
    storageAccountName: stgName
    location: location
  }
}

// ________________________________ Netwerk ____________________________________________________________

// module vnet 'mod-vnet.bicep' =[for x in range(length(0, vnetName)):{
//   name: vnetName[x]
//   params:{
//   }
// }]


// var initScriptUrl = uri(_artifactsLocation, 'initialize.ps1${_artifactsLocationSasToken}')
// var sshdConfigUrl = uri(_artifactsLocation, 'configs/sshd_config_wopwd${_artifactsLocationSasToken}')

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'publicIP'
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

resource nsg2 'Microsoft.Network/networkSecurityGroups@2020-04-01' = {
  name: 'nsg2'
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
var vnet1Config = {
  addressSpacePrefix: vnetPrefix[0]
  subnetName: subnetName[0]
  subnetPrefix: vnetPrefix[0]
}

var vnet2Config = {
  addressSpacePrefix: vnetPrefix[1]
  subnetName: subnetName[1]
  subnetPrefix: vnetPrefix[1]
}

resource vnet1 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName[0]
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
          networkSecurityGroup: {
            id: nsg.id
          }
        }  
      }      
    ]
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName[1]
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2Config.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnet2Config.subnetName
        properties: {
          addressPrefix: vnet2Config.subnetPrefix
          networkSecurityGroup: {
            id: nsg2.id 
          }
        }
      }
    ]
  }
}
output state2 string = 'vnets_deployed' 

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet1
  name: '${vnetName[0]}-${vnetName[1]}'
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

resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnet2
  name: '${vnetName[1]}-${vnetName[0]}'
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

resource nic 'Microsoft.Network/networkInterfaces@2020-04-01' = {
  name: 'nic'
  location: location
  tags: {
    displayName: 'Network Interface'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: vnet1.id
          }
        }
      }
    ]
  }
}
output state3 string = 'peering_deployed' 

//_____________________________ VM _________________________________________________________________

// module vm 'mod-vm.bicep' = {
//   name: stgName
//   params:{
//     location: location
//     storageAccountName: 'test_stg'
//     subnet: 
//     adminUser: adminUser
//     vmsize: vmsize
//     publicSshKey: publicSshKey
//   }
// }

resource datadisk 'Microsoft.Compute/disks@2020-09-30' = {
  name: 'datadisk'
  location: location
  properties: {
    diskSizeGB: diskSizeGB
    creationData: {
      createOption: 'Empty'
    }
  }
  sku: {
    name: diskSku
  }
}

resource webvm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'webvm'
  location: location
  tags: {
    displayName: 'Windows Server with SSH'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmsize
    }
    osProfile: {
      computerName: 'webServer'
      adminUsername: adminUser
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmSku
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          createOption: 'Attach'
          lun: 0
          managedDisk: {
            id: datadisk.id
          }
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        //storageUri: stgName.properties.primaryEndpoints.blob
      }
    }
  }
}

// resource sshhost_setupScript 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = {
//   parent: webvm
//   name: 'setupScript'
//   location: location
//   tags: {
//     displayName: 'Setup script for SSH'
//   }
//   properties: {
//     publisher: 'Microsoft.Compute'
//     type: 'CustomScriptExtension'
//     typeHandlerVersion: '1.10'
//     autoUpgradeMinorVersion: true
//     settings: {
//       fileUris: [
//         initScriptUrl
//         sshdConfigUrl
//       ]
//     }
//     protectedSettings: {
//       commandToExecute: 'powershell -ExecutionPolicy Bypass -file initialize.ps1 -publicSshKey "${publicSshKey}"'
//     }
//   }
// }

// output sshhost_connect string = 'ssh ${adminUser}@${publicIP.properties.dnsSettings.fqdn}'
