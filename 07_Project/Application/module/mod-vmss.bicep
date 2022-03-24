param clientVar object
param vnetVar object
param tags object
param vmVar object
param agw string = 'appGateway'
param bePool string = 'bePool'
param stgName string
param kvVar object
@secure()
param SSH string

//-Reference
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: 'subnet${i+1}'
}]
resource dskEncrKey 'Microsoft.Compute/diskEncryptionSets@2021-08-01' existing = {
  name: 'dskEncrKey-${clientVar.client}'
}
resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' existing = {
  name: 'Admin_Server'
}
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: clientVar.client
}
resource sa 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name:stgName
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
}
resource appGateway 'Microsoft.Network/applicationGateways@2021-05-01' existing = {
  name: agw
}
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' existing = {
  name: '/SSLcert'
}
resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-05-01' existing = {
  name: 'nsg-${vnetVar.environment[0]}'
}

//- Deploy VMSS
resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' = {
  name: 'vmss-web-${clientVar.client}'
  location: clientVar.location
  tags: tags
  properties: {
    virtualMachineProfile: {
      diagnosticsProfile:{
        bootDiagnostics:{
          enabled: true
        }
      }
      osProfile: {
        allowExtensionOperations:true
        computerNamePrefix: 'web-server'
        adminUsername: clientVar.client
        customData: loadFileAsBase64('../etc/apache_install.sh')
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh:{
            publicKeys:[
              {
                path: '/home/${clientVar.client}/.ssh/authorized_keys'
                keyData: SSH
              }
            ]
          }
        }
      }
      extensionProfile:{
        extensions:[
          {
            name: 'healthRepairExtension'
            properties:{
              autoUpgradeMinorVersion: true
              publisher: 'Microsoft.ManagedServices'
              type: 'ApplicationHealthLinux'
              typeHandlerVersion: '1.0'
              settings:{
                protocol: 'http'
                port: 80
                requestPath: '/'
              }
            }
          }
          {
            name: 'KeyVaultForLinux'
            properties: {
              publisher: 'Microsoft.Azure.KeyVault'
              type: 'KeyVaultForLinux'
              typeHandlerVersion: '2.0'
              autoUpgradeMinorVersion: true
              settings:{
                secretsManagementSettings: {
                  pollingIntervalInS: '6000'
                  certificateStoreLocation: '/etc/ssl/certs'
                  requireInitialSync: true
                  observedCertificates: [
                    'https://${toLower(kvVar.kvName)}${environment().suffixes.keyvaultDns}/secrets/SSLcert'
                   ] 
                }
              }
            }
          }
          // TO DO EXTRA: POST BOOT script/functions
          // {
          //   name: 'config-app'
          //   properties:{
          //     publisher: 'Microsoft.Azure.Extensions'
          //     type: 'CustomScript'
          //     typeHandlerVersion: '2.1'
          //     autoUpgradeMinorVersion: true
          //     protectedSettings: {
          //       managedIdentity:{
          //         '${mngId.id}':{}
          //       }
          //       fileUris:[
          //         'https://${stgName}.blob.${environment().suffixes.storage}/website/website.zip'
          //       ]
          //     }
          //   }
          // }
        ]
      }
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            diskEncryptionSet: {
              id: dskEncrKey.id
            }
          }
        }
        imageReference: {
          publisher: 'canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: vmVar.vmSkuL
          version: 'latest'
        }
      }
      networkProfile: {
        //networkApiVersion:'2020-11-01'
        networkInterfaceConfigurations: [
          {
            name: 'app-prd-vnet-nic'
            properties:{
              networkSecurityGroup:{
                id: nsg1.id
              }
              primary: true
              ipConfigurations: [
                {
                  name: 'ipConfigWeb'
                  properties:{
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet[0].name, 'subnet1')
                    }
                    primary: true
                    applicationGatewayBackendAddressPools:[
                      {
                        id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools/', agw, bePool)
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
  }
  orchestrationMode: 'Uniform'
  scaleInPolicy: {
    rules:[
      'OldestVM'
    ]
  }
  overprovision: true
  upgradePolicy: {
    mode: 'Automatic'
  }
  automaticRepairsPolicy: {
    enabled: true
    gracePeriod: 'PT10M'
  }
  platformFaultDomainCount: 1
  }
  sku: {
    name: vmVar.vmSizeL
    capacity: 1
    tier: 'Standard'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}':{}
    }
  }
  zones:[
    '1'
  ]
}

resource vmssScaling 'Microsoft.Insights/autoscalesettings@2021-05-01-preview' ={
  name: 'vmssScaleSettings'
  location: clientVar.location
  tags: tags
  properties:{
    profiles: [
      {
        name: 'vmssScaleSettings'
        capacity: {
          default: '1'
          maximum: '3'
          minimum: '1'
        }
        rules: [
          {
            scaleAction: {
              cooldown: 'PT5M'
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
            }
            metricTrigger: {
              metricName: 'CurrentConnections'
              metricResourceUri: appGateway.id
              operator: 'GreaterThan'
              statistic: 'Sum'
              threshold: 2500
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
              dividePerInstance: true
            }
          }
          {
            scaleAction: {
              cooldown: 'PT5M'
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
            }
            metricTrigger: {
              metricName: 'CurrentConnections'
              metricResourceUri: appGateway.id
              operator: 'LessThanOrEqual'
              statistic: 'Sum'
              threshold: 2500
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT10M'
              dividePerInstance: true
            }
          }
          {
            scaleAction: {
              cooldown: 'PT5M'
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
            }
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmss.id
              operator: 'GreaterThan'
              statistic: 'Sum'
              threshold: 70
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT5M'
              dividePerInstance: false
            }
          }
          {
            scaleAction: {
              cooldown: 'PT5M'
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
            }
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: vmss.id
              operator: 'LessThanOrEqual'
              statistic: 'Sum'
              threshold: 70
              timeAggregation: 'Average'
              timeGrain: 'PT1M'
              timeWindow: 'PT10M'
              dividePerInstance: false
            }
          }
        ]
      }
    ]
    enabled: true
    targetResourceUri: vmss.id
  }
}
