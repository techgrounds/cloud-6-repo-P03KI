
param adminUser string

@secure()
param adminPassword string = newGuid()
param publicSshKey string

@description('VM size for VM')
param vmsize string 

@description('SKU of the Windows Server')
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
param pip string
// param _artifactsLocation string = deployment().properties.templateLink.uri

// @description('SAS Token for accessing script path')
// @secure()
// param _artifactsLocationSasToken string = ''

 var initScriptUrl = uri(_artifactsLocation, 'initialize.ps1${_artifactsLocationSasToken}')
 var sshdConfigUrl = uri(_artifactsLocation, 'configs/sshd_config_wopwd${_artifactsLocationSasToken}')



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
            id: 'pip'
          }
          subnet: {
            id: 'subnet'
          }
        }
      }
    ]
  }
}

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

resource sshhost 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'sshhost'
  location: location
  tags: {
    displayName: 'Windows Server with SSH'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmsize
    }
    osProfile: {
      computerName: 'sshhost'
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
        storageUri: storageAccount.properties.primaryEndpoints.blob
      }
    }
  }
}

resource sshhost_setupScript 'Microsoft.Compute/virtualMachines/extensions@2021-07-01' = {
  parent: sshhost
  name: 'setupScript'
  location: location
  tags: {
    displayName: 'Setup script for SSH'
  }
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        initScriptUrl
        sshdConfigUrl
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Bypass -file initialize.ps1 -publicSshKey "${publicSshKey}"'
    }
  }
}

output sshhost_connect string = 'ssh ${adminUser}@${publicIP.properties.dnsSettings.fqdn}'
