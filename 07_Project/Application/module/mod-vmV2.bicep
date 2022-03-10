//- Scope 
targetScope = 'resourceGroup'

//- Parameters 
param kvVar object
param vnetVar object
param sshK string
param tags object
param clientVar object
param vmVar object
@secure()
param adpw string 

//- Reference
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: { 
  name:'pubIp${i+1}'
}]
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]
resource dskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' existing = {
  name: 'dskEncrKey-${clientVar.client}'
}
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: clientVar.client
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
  scope: resourceGroup('resGr')
}

//- Set up NIC's 
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = [for (vnetName, i) in vnetVar.vnetName: {
  name: 'webNIC${i}'
  location: clientVar.location
  tags:tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfigWeb${i}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pubIp[i].id
          }
          subnet: {
            id: '${vnet[i].id}/subnets/subnet${i}'
          }
        }
      }
    ]
  }
}]

////////////////////////   Data Disk   ///////////////////////////////////
resource datadisk 'Microsoft.Compute/disks@2021-08-01' = {
  name: 'xt_DataDisk'
  location: clientVar.location
  tags:tags
  properties: {
    diskSizeGB: vmVar.diskSizeGB
    creationData: {
      createOption: 'Empty'
    }
    encryption:{
      type: 'EncryptionAtRestWithCustomerKey'
      diskEncryptionSetId: dskEncrKey.id
    }
    networkAccessPolicy: 'DenyAll'
    osType: 'Linux'
    }
  
  sku: {
    name: vmVar.diskSku
  }
  zones:[
    '1'
  ]
}
////////////////////////   Webserver  /////////////////////////////////////
resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'Web_Server'
  location: clientVar.location
  tags:tags
  zones:[
    '1'
  ]
  identity:{
    type:'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}' : {}
    }
  }
  properties: {
    hardwareProfile: {
      vmSize: vmVar.vmSizeL
    }
    osProfile: {
      computerName: 'Web-Server'
      adminUsername: clientVar.user
      allowExtensionOperations: true
      customData: loadFileAsBase64('../etc/apache_install.sh')
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              keyData: sshK
              path: '/home/${clientVar.user}/.ssh/authorized_keys'
            }
          ]
        }
      }  
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: vmVar.vmSkuL
        version: 'latest'
      }
      osDisk: {
      deleteOption:'Detach'
        osType: 'Linux'
        name: 'Web_OSDisk'
        diskSizeGB: 16
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType:'Standard_LRS'
          diskEncryptionSet:{
            id: dskEncrKey.id
          }
        }
      }
      dataDisks: [
        {
          createOption: 'Attach'
          lun: 0
          managedDisk: {
            storageAccountType: vmVar.diskSku
            diskEncryptionSet: {
              id: dskEncrKey.id
            }
            id: datadisk.id
          }
        }
      ]
      
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[0].id
        }
      ]
    }
  }
}

////////////////////   Set up Admin Server   //////////////////////////////
resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'Admin_Server'
  location: clientVar.location
  tags:tags
  identity:{
    type:'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}' : {}
    }
  }
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
        diskSizeGB: 16
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
          id: nic[1].id
        }
      ]
    }
  }
  zones:[
    '1'
  ]
}
