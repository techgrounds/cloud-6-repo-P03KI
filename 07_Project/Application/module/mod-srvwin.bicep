param clientVar object
param tags object
param vmVar object
@secure()
param adpw string
param nic string

resource dskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' existing= {
  name: 'dskEncrKey-${clientVar.client}'
}


resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'Admin_Server'
  location: clientVar.location
  tags:tags
  properties: {
    priority: 'Regular'
    hardwareProfile: {
      vmSize: vmVar.vmSizeW
    }
    osProfile: {
      computerName: 'Admin-Server'
      adminUsername: clientVar.user
      adminPassword: adpw
      //allowExtensionOperations: true
      windowsConfiguration:{
        provisionVMAgent:true
      }
    }
    licenseType: 'Windows_Client'
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition' 
        version: 'latest'
      }
      osDisk: {
        name: 'Adm_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk:{
          storageAccountType: vmVar.diskSku
          diskEncryptionSet: {
          id: dskEncrKey.id
          }
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic
        }
      ]
    }
  }
  zones:[
    '1'
  ]
}

output admVmId string = admvm.id
output admSrvName string = admvm.name
