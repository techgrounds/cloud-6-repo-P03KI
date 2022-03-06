//----------- Scope ---------------------------------------------------------------------
targetScope = 'resourceGroup'
//------- VAR ---------------------------------------------------------------------------
param pip1 string
param pip2 string
param subId1 string
param subId2 string
param sshK string
param tags object
//param kvUri string
param dskEncrKey string
param clientVar object
param vmVar object
@secure()
param pwdWin string
//----------------------- Set up NIC's --------------------------------------------------
resource nic1 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'webNIC1'
  location: clientVar.location
  tags:tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfigWeb1'
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
resource nic2 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'webNIC2'
  location: clientVar.location
  tags:tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfigWeb2'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip2
          }
          subnet: {
            id: subId2
          }
        }
      }
    ]
  } 
}
//-------------------- Set up Webserver -------------------------------------------------
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
      diskEncryptionSetId: dskEncrKey
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
resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'Web_Server'
  location: clientVar.location
  tags:tags
  zones:[
    '1'
  ]
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
        diskSizeGB: 30
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType:'Standard_LRS'
          diskEncryptionSet:{
            id: dskEncrKey
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
              id: dskEncrKey
            }
            id: datadisk.id
          }
        }
      ]
      
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic1.id
        }
      ]
    }
  }
}

//-------------------- Set up Admin Server ----------------------------------------------
resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'Admin_Server'
  location: clientVar.location
  tags:tags
  properties: {
    priority: 'Spot'
    hardwareProfile: {
      vmSize: vmVar.vmSizeW
    }
    osProfile: {
      computerName: 'Admin-Server'
      adminUsername: clientVar.user
      adminPassword: pwdWin
      allowExtensionOperations: true
      windowsConfiguration:{
        provisionVMAgent:true
      }
    }
    licenseType: 'Windows_Client'
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'windows-11'
        sku: vmVar.vmSkuW
        version: 'latest'
      }
      osDisk: {
        name: 'Adm_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk:{
          storageAccountType: vmVar.diskSku
          diskEncryptionSet: {
          id: dskEncrKey
          }
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic2.id
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
output webSrvName string = webvm.name
output webVmId string = webvm.id
output webDisk string = webvm.properties.storageProfile.osDisk.managedDisk.id
