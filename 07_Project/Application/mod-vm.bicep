param pip1 string
param kvObj object
//param pip2 string
param subId1 string
//param subId2 string
param vmObj object
//@secure()
//param sshKey string
targetScope = 'resourceGroup'

// resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
//   name: vmObj.kvName 
//   scope: resourceGroup(subscription().id, resourceGroup().name )
// }

//--------------------- Set KV --------------------------------
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: kvObj.kvName
  location: kvObj.location
  properties: {
    enabledForDeployment: kvObj.enabledForDeployment
    enabledForDiskEncryption: kvObj.enabledForDiskEncryption
    enabledForTemplateDeployment: kvObj.enabledForTemplateDeployment
    enableRbacAuthorization: false
    tenantId: subscription().tenantId
    ////////// Temporary for testdeployments ///////////////////////
    enablePurgeProtection:false
    enableSoftDelete: false
    //////////////////////////////////////////////////////////////
    accessPolicies: [
      {
        objectId: kvObj.objectId
        tenantId: kvObj.tenantId
        permissions: {
          keys: kvObj.keysPermissions
          secrets: kvObj.secretsPermissions
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
resource DskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
  name: 'DskEncrKey'
  location: kvObj.location
 
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      keyUrl: 'string'
      sourceVault: {
        id: kv.id
      }
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    //rotationToLatestKeyVersionEnabled: bool
  }
}

resource ssh_web 'Microsoft.Compute/sshPublicKeys@2021-11-01' = {
  name: 'ssh_web'
  location: kvObj.location
  properties: {
    publicKey: kvObj.pubSSH
  }
  dependsOn:[
    kv
  ]
}
//-------------------- Set up Webserver ------------------------
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
resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'webvm'
  location: vmObj.location
  zones:[
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmObj.vmSize
    }
    osProfile: {
      computerName: 'Web-Server'
      adminUsername: vmObj.adminUser
      adminPassword: vmObj.adminPassword
      //linuxConfiguration: ((authenticationType == 'password') ? json('null') : linuxConfiguration)
      customData: loadTextContent('apache_install.sh')
      // linuxConfiguration: {
      //   disablePasswordAuthentication: true
      //   // patchSettings: {
      //   //   assessmentMode: 'string'
      //   //   patchMode: 'string'
      //   // }
      //   //provisionVMAgent: bool
      //   ssh: {
      //     publicKeys: [
      //       {
      //         keyData: vmObj.SSH 
      //         //path: 'string'
      //       }
      //     ]
      //   }
      // }
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: vmObj.vmSku
        version: 'latest'
      }
      osDisk: {
        name: 'Web_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        // encryptionSettings:{
        //   enabled:true
        //   diskEncryptionKey:{
        //     sourceVault: {
              
        //     }
        //     secretUrl: 
        //   }
        // }
      }
      
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
  dependsOn:[
    kv
  ]
}

// resource webvm_install_apache 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
//   parent: webvm
//   name: 'install_apache'
//   location: vmObj.location
//   properties: {
//     publisher: 'Microsoft.Azure.Extensions'
//     type: 'CustomScript'
//     typeHandlerVersion: '2.1'
//     autoUpgradeMinorVersion: true
//     settings: {
//       skipDos2Unix: false
//       fileUris: [
//         'https://gist.githubusercontent.com/daveRendon/72986871085786d04d0cdc2b1065355b/raw/34b2a4b5e05dc32f695c8236c89a2c62ce6213ca/install_apache.sh'
//       ]
//     }
//     protectedSettings: {
//       commandToExecute: 'sh install_apache.sh'
//     }
//   }
// }

//-------------------- Set up Admin Server ---------------------
resource datadisk 'Microsoft.Compute/disks@2021-08-01' = {
  name: 'datadisk'
  location: vmObj.location
  properties: {
    diskSizeGB: vmObj.diskSizeGB
    creationData: {
      createOption: 'Empty'
    }
  }
  sku: {
    name: vmObj.diskSku
  }
}

resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'admvm'
  location: vmObj.location
  properties: {
    hardwareProfile: {
      vmSize: vmObj.vmsize
    }
    osProfile: {
      computerName: 'Admin-Server'
      adminUsername: vmObj.adminUser
      adminPassword: vmObj.adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: vmObj.vmSku
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
  }
  dependsOn:[
    kv
  ]
}
