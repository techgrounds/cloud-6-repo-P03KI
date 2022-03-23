//- Scope 
targetScope = 'resourceGroup'

//- Parameters 
param kvVar object
param vnetVar object
param privIp string
param tags object
param clientVar object
param vmVar object
@secure()
param adpw string 

//- Reference
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: { 
  name: 'pubIp-${vnetVar.environment[i]}'
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
// resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = {
//   name: 'nsg-${vnetVar.environment[1]}'
// }

//- Create NSG
resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-05-01' =  {
  name: 'nsg-${vnetVar.environment[1]}'
  location: clientVar.location
  tags:tags
  properties:{
    securityRules: [
    {
      name: 'rdp'
      properties: {
        description: 'rdp-rule'
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '3389'
        sourceAddressPrefix: privIp
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
        sourceAddressPrefix: privIp
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 110
        direction: 'Inbound'
      }
    }
    ]
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
      allowExtensionOperations: true
      windowsConfiguration:{
        provisionVMAgent:true
      }
      // customData:'''
      // $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
      // Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
      // Set-ItemProperty $RegPath "DefaultUsername" -Value "$username" -type String 
      // Set-ItemProperty $RegPath "DefaultPassword" -Value "$password" -type String
      // '''
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
        diskSizeGB: 128
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
          id: nic2.id
        }
      ]
    }
  }
  zones:[
    '1'
  ]
}

//- Set up NIC 
resource nic2 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'adm-prd-vnet-nic'
  location: clientVar.location
  tags:tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfigAdm'
        properties: {
          publicIPAddress: {
            id: pubIp[1].id
          }
          subnet: {
            id: '${vnet[1].id}/subnets/subnet2'
          }
        }
      }
    ]
    networkSecurityGroup:{
      id: nsg2.id
    }
  }
}

resource dlPrivKey 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  kind:'AzurePowerShell'
  location: clientVar.location
  identity:{
    type:'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}':{}
    }
  }
  name: 'dl_priv_key_cli'
  tags: tags
  properties:{
    retentionInterval: 'P1D'
    azPowerShellVersion: '5.1.20348.558'
    environmentVariables: [
      {
        name: 'kvname'
        value: kvVar.kvName
      }
      {
        name: 'secr'
        value: 'privSSH'
      }
      {
        name: 'path'
        value: 'c:/priv.ppk'
      }
    ]
    scriptContent:'az keyvault secret download -vault-name $env:kvname -name $env:secr -file $env:path' 
    timeout: 'PT10M'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn:[
    admvm
  ]
}

//

//Install-Module -Name PowerShellGet -Force -Scope CurrentUser
//az keyvault secret download -vault-name kvXYZ10331 -name privSSH -file c:/priv.ppk
// resource autoLogin 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   kind:'AzurePowerShell'
//   location: clientVar.location
//   name: 'autoLoginScript'
//   identity:{
//     type:'UserAssigned'
//     userAssignedIdentities:{
//       '${mngId.id}':{}
//     }
//   }
//   properties:{
//     retentionInterval: 'P1D'
//     azPowerShellVersion: '7.2.2'
//     scriptContent: '''
//     $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
//     Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
//     Set-ItemProperty $RegPath "DefaultUsername" -Value "$username" -type String 
//     Set-ItemProperty $RegPath "DefaultPassword" -Value "$password" -type String
//     '''
//   }
//   dependsOn:[
//     admvm
//   ]
// }
