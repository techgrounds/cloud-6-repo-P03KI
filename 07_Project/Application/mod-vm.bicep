
param adminUser string
param pip string
param publicSshKey string
param vmsize string

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  scope: resourceGroup()
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
            id: pubId
          }
          subnet: {
            id: vnet.id
          }
        }
      }
    ]
  }
}

param erre 
resource datadisk 'Microsoft.Compute/disks@2021-08-01' = {
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
resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'webvm'
  location: location
  tags: {
    displayName: 'webServerLNX'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmsize
    }
    osProfile: {
      computerName: 'webServer'
      adminUsername: adminUser
      adminPassword: adminPassword
      customData: loadTextContent('apache_install.sh')
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
  }
}
