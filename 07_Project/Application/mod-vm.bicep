param vmObj object
param pip1 string
//param pip2 string
param subId1 string
//param subId2 string

targetScope = 'resourceGroup'

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'webNIC'
  location: vmObj.location
  tags: {
    displayName: 'webNIC'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfigWeb'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip1
          }
          subnet: {
            id: subId1
          }
        }
      }
    ]
  }
}

resource webvm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: 'webvm'
  location: vmObj.location
  properties: {
    hardwareProfile: {
      vmSize: vmObj.vmSize
    }
    osProfile: {
      computerName: 'Admin-Server'
      adminUsername: vmObj.adminUser
      adminPassword: vmObj.pubSSH
      //linuxConfiguration: ((authenticationType == 'password') ? json('null') : linuxConfiguration)
    }
    storageProfile: {
      imageReference: {
        publisher: 'imagePublisher'
        offer: imageOffer
        sku: ubuntuOSVersion
        version: 'latest'
      }
      osDisk: {
        name: '${vmName_var}_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
  }
  dependsOn: [
    nic
  ]
}
resource vmName_install_apache 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  parent: vmName
  name: 'install_apache'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      skipDos2Unix: false
      fileUris: [
        'https://gist.githubusercontent.com/daveRendon/72986871085786d04d0cdc2b1065355b/raw/34b2a4b5e05dc32f695c8236c89a2c62ce6213ca/install_apache.sh'
      ]
    }
    protectedSettings: {
      commandToExecute: 'sh install_apache.sh'
    }
  }
}

// resource datadisk 'Microsoft.Compute/disks@2021-08-01' = {
//   name: 'datadisk'
//   location: vmObj.location
//   properties: {
//     diskSizeGB: vmObj.diskSizeGB
//     creationData: {
//       createOption: 'Empty'
//     }
//   }
//   sku: {
//     name: vmObj.diskSku
//   }
// }

// resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
//   name: 'webvm'
//   location: vmObj.location
//   tags: {
//     displayName: 'webServerLNX'
//   }
//   properties: {
//     hardwareProfile: {
//       vmSize: vmObj.vmsize
//     }
//     osProfile: {
//       computerName: 'webServer'
//       adminUsername: vmObj.adminUser
//       adminPassword: vmObj.adminPassword
//       customData: loadTextContent('apache_install.sh')
//     }
//     storageProfile: {
//       imageReference: {
//         publisher: 'MicrosoftWindowsServer'
//         offer: 'WindowsServer'
//         sku: vmObj.vmSku
//         version: 'latest'
//       }
//       osDisk: {
//         name: 'osdisk'
//         caching: 'ReadWrite'
//         createOption: 'FromImage'
//       }
//       dataDisks: [
//         {
//           createOption: 'Attach'
//           lun: 0
//           managedDisk: {
//             id: datadisk.id
//           }
//         }
//       ]
//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: nic.id
//         }
//       ]
//     }
//   }
// }
