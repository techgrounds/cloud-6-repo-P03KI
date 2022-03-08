
targetScope = 'resourceGroup'

@description('location of the resources')//outputs from main
param location string = resourceGroup().location

@description('tags for the resources')
param tagValue object = {
  project: 'version1.0'
}

@description('naming of the resources')
param keyVaultName string = 'vault${uniqueString(resourceGroup().id)}'
param keyName string = 'key${uniqueString(resourceGroup().id)}'
param diskEncrypName string = 'encrypt${uniqueString(resourceGroup().id)}'
param managedIdName string = 'manId${uniqueString(resourceGroup().id)}'
param accesPoliciesName string = 'add'

@description('specify userdata')
param tenantId string = subscription().tenantId
param objectId string = 'de00d0e9-03c6-457c-bfff-0e295242fd26'


resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  tags: tagValue
  properties: {
    accessPolicies: [
      {
        objectId: objectId
        permissions: {
          certificates: [
            'all'
          ]
          keys: [
            'all' 
          ]
          secrets: [
            'all'
          ]
          storage: []
        }
        tenantId: tenantId
      }
    ]
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    //enablePurgeProtection: true
    enableRbacAuthorization: false
    //enableSoftDelete: false
    softDeleteRetentionInDays: 7
    //publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
  }
}

resource keyVaultKey 'Microsoft.KeyVault/vaults/keys@2021-11-01-preview' = {
  name: keyName
  tags: tagValue
  parent: keyVault
  properties: {
    keyOps: [
      'decrypt'
      'encrypt'
      'sign'
      'unwrapKey'
      'verify'
      'wrapKey'
    ]
    keySize: 4096
    kty:'RSA'
  }
}

resource diskencryptionset 'Microsoft.Compute/diskEncryptionSets@2021-08-01' = {
  name: diskEncrypName
  location: location
  tags: tagValue
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVault.id
      }
      keyUrl: keyVaultKey.properties.keyUriWithVersion
    }
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    rotationToLatestKeyVersionEnabled: true
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdName
  location: location
  tags: tagValue
  dependsOn: [
    keyVault
  ]
}

resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  name: accesPoliciesName
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: diskencryptionset.identity.principalId
        permissions: {
          keys: [
            'all'
          ]
          secrets: []
          certificates: []
          storage: [
            'all'
          ]
        }
      }
      {
        tenantId: tenantId
        objectId: managedIdentity.properties.principalId
        permissions: {
          keys: [
            'all' 
          ]
          secrets: []
          certificates: []
          storage: [
            'all'
          ]
        }
      }
    ] 
  }
}

@description('output of the resources')
output keyvaultUri string = keyVault.properties.vaultUri
output keyname string = keyVaultKey.name
output diskencryptionId string = diskencryptionset.id
output managedId string = managedIdentity.id

@description('parameters to get out of main module')
param tagValues object = {
  project:'version1'
}
param trustedIP array = []

@description('naming of the resources')
param adminSecurityName string = 'admin-nsg'
param adminSecRules string = 'admin-nsg-rules'
param adminPublicIpName string = 'publicIP1'
param nicName string = 'adminnic'
param vNetAdminName string = 'admin-vnet'
param adminUserName string = 'adminUser1'

param enviorment string = 'testing'
param adminvmName string = 'avm${enviorment}'

@description('vnet configurations')
var vnetadminConfig = {
  addressSpacePrefix: '10.10.10.0/24'
  subnetName: 'subnet1'
  subnetPrefix: '10.10.10.0/24'
}

@description('configurations VM')
param adminvmSize string = 'Standard_B1s'

@description('password for the admin VM')
@secure()
param adminPassword string 

param OSVersion1 string = '2022-datacenter-azure-edition'


resource adminSecGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: adminSecurityName
  location: location
  tags: tagValues
  properties: {
    securityRules: [
      {
        name: adminSecRules
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '3389'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 1000
          protocol:'Tcp'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: trustedIP
          sourcePortRange: '*'
          sourcePortRanges: []
        }
      }
    ]
  }
}

resource publicIPadmin 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: adminPublicIpName
  location: location
  tags: tagValues
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource vnetadmin 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetAdminName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetadminConfig.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnetadminConfig.subnetName
        properties: {
          addressPrefix: vnetadminConfig.subnetPrefix
          networkSecurityGroup: {
            id: adminSecGroup.id
          }
        }
      }
    ]
  }
}

resource adminNIC 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: nicName
  location: location
  tags: tagValues
  properties: {
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: true
    ipConfigurations: [
      {
        name: 'AdminIpConvig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPadmin.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetadmin.name, vnetadminConfig.subnetName)
          }
          primary: true
          privateIPAddress: 'IPv4'
        }
      }
    ]
  }
}

resource admin_vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: adminvmName
  location: location
  tags: tagValues
  zones: [
    '1'
  ]
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    hardwareProfile: {
      vmSize: adminvmSize
    }
    licenseType: 'Windows_Server'
    networkProfile: {
      networkInterfaces: [
        {
          id: adminNIC.id
          properties: {
            deleteOption: 'Detach'
            primary: true
          }
        }
      ]
    }
    osProfile: {
      adminPassword: adminPassword
      adminUsername: adminUserName
      allowExtensionOperations: true
      computerName: adminvmName
      secrets: []
      windowsConfiguration: {
        enableAutomaticUpdates: true
        patchSettings: {
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }
      storageProfile: {
        imageReference: {
        offer: 'WindowsServer'
        publisher: 'MicrosoftWindowsServer'
        sku: OSVersion1
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          diskEncryptionSet: {
            id: diskencryptionset.id
          }
          storageAccountType: 'Standard_LRS'
        }
        osType: 'Windows'
      }
    }
  }
}

@description('the output of the resources')
output vnetAdminiD string = vnetadmin.id
output adminvnetname string = vnetadmin.name

param enviroment string = 'testing'
@description('naming of the resources')
param webSecurityName string = 'web-nsg'
param webSecRules1 string = 'web-https-rules'
param webSecRules2 string = 'web-http-rules'
param webSecRules3 string = 'web-ssh-rules'
param publicIpName string = 'publicIP2'
param webnicName string = 'webnic'
param vNetWebName string = 'web-vnet'
param webVMname string = 'webvm${enviroment}'
param webUserName string = 'webusername'

param pubkey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQs1xF11mYdmWMSa8DYsez0XIQw2LMf9jr7TmAXSg1vfl0q1dd8p6PcuNFqNH7eXz+AGhBAXcDMUe4Vtu1nEMp5ck9TMH1SXEl5uK0ogNWfehHzVM+6KFNIq9WQSwsZGibdRN75Qm3ZbZseIILvKMfPO+1FX0nbo+N9I240QQDCq7rGgSRZ6IiW6n4Wgh9zMP+eWnYEni8LAwRGprhZy8nszf9l8Cpzflgc+KrjPgfcw6i12kp/ZL+cTiHZrO+glIjnnSMUrlpX3rRZjUbJmLyIoVCUj8PVW9KgWgDfG3XeMjqoOQu9QSuCY4rdeaMK4qPeTodORVwYi9Yhe5NiGswdNaImh3TeMeIZjuBBQo/5x7iNTMg+4k5uDd9S89vMNJeCgdaMBC3RSHkpHBijcB0PukapEZbIPThn49JlzssfAn42K+XcRCrmta5MoSN4kwCysGxyxONT0S/LrFP9uWlJ8zjWKMpJJl4xwN7X/23qqsYlzcX9SDyjy5MVOhnRrkyGymu3ASzDdAHmX7IaXiWwyVEhWkldrEkmBEuAzI4dLCJUTPL+6WUdMfPtGud4m1wYfRg9BLrKSxn+3MdTDkp1GGGfay9AQBs4XWfkKkz6IKyu6VgFhtVD8eH+pPE/LlZPDJ1xl/A+BVIyXx1s+UhFwrVCohmQPH1KtwZ3BSnNw== mylen@LAPTOP-CSG64OIC'

@description('vnet configurations')
var vnetwebConfig = {
  addressSpacePrefix: '10.20.20.0/24'
  subnetName: 'subnet1'
  subnetPrefix: '10.20.20.0/24'
}

@description('configurations VM')
param webvmSize string = 'Standard_B1s'

@description('password for the admin VM')
@secure()
param webPassword string

@description('Windows version for the VM; picks a fully patched Gen2 image of this given Windows version.')
param OSVersion string = '21_10-gen2'

resource webSecGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: webSecurityName
  location: location
  tags: tagValues
  properties: {
    securityRules: [
      {
        name: webSecRules1
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '443'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 1000
          protocol:'Tcp'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
      }
      {
        name: webSecRules2
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '80'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 1500
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: []
          sourcePortRange: '*'
          sourcePortRanges: []
        }
      }
      {
        name: webSecRules3
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationAddressPrefixes: []
          destinationPortRange: '22'
          destinationPortRanges: []
          direction: 'Inbound'
          priority: 2000
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourceAddressPrefixes: trustedIP
          sourcePortRange: '*'
          sourcePortRanges: []
        }
      }
    ]
  }
}

resource publicIPweb 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpName
  location: location
  tags: tagValues
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource vnetweb 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetWebName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetwebConfig.addressSpacePrefix
      ]
    }
    subnets: [
      {
        name: vnetwebConfig.subnetName
        properties: {
          addressPrefix: vnetwebConfig.subnetPrefix
          networkSecurityGroup: {
            id: webSecGroup.id
          }
        }
      }
    ]
  }
}

resource webNIC 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: webnicName
  location: location
  tags: tagValues
  properties: {
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'AdminIpConvig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPweb.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetweb.name, vnetwebConfig.subnetName)
          }
          primary: true
          privateIPAddress: 'IPv4'
        }
      }
    ]
  }
}

resource webVM 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: webVMname
  location: location
  tags: tagValues
  zones: [
    '1'
  ]
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    hardwareProfile: {
      vmSize: webvmSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: webNIC.id
          properties: {
            deleteOption: 'Detach'
            primary: true
          }
        }
      ]
    }
    osProfile: {
      adminPassword: webPassword
      adminUsername: webUserName
      allowExtensionOperations: true
      computerName: webVMname
      linuxConfiguration: {
        disablePasswordAuthentication: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        provisionVMAgent: true
        ssh: {
          publicKeys: [
            {
              keyData: pubkey
              path: '/home/${webUserName}/.ssh/authorized_keys'
            }
          ]
        }
      }
      secrets: []
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-impish'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          diskEncryptionSet: {
            id: diskencryptionset.id
          }
          storageAccountType: 'Standard_LRS'
        }
        osType: 'Linux'
      }
    }
  }
}

resource VnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnetadmin
  name: '${vNetAdminName}-${vNetWebName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetweb.id
    }
  }
}


resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  parent: vnetweb
  name: '${vNetWebName}-${vNetAdminName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetadmin.id
    }
  }
}

@description('naming of the resources')
param storageAccountName string = 'storacc${uniqueString(resourceGroup().id)}'
param storageblobName string = 'storblob${uniqueString(resourceGroup().id)}'
param containerName string = 'cont${uniqueString(resourceGroup().id)}'

// create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  tags: tagValues
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    allowCrossTenantReplication: true
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: false
    encryption: {
      identity: {
        userAssignedIdentity: managedIdentity.id
      }
      keySource: 'Microsoft.Keyvault'
      keyvaultproperties: {
        keyname: keyName
        keyvaulturi: keyVault.properties.vaultUri
      }
      requireInfrastructureEncryption: false
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Account'
        }
        table: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    supportsHttpsTrafficOnly: true
  }
}

// create blobservice
resource blobsevice 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  name: storageblobName
  parent: storageAccount
  properties: {
    changeFeed: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      days: 7
      enabled: true
    }
    isVersioningEnabled: false
    restorePolicy: {
      enabled: false
    }
  }
}

// create container
resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: containerName
  parent: blobsevice
  properties: {
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    immutableStorageWithVersioning: {
      enabled: false
    }
    publicAccess: 'None'
  }
}

@description('naming of the resources')
param recoveryvaultName string = 'recvault${uniqueString(resourceGroup().id)}'
param backupPoliciesName string = 'bPolicy${uniqueString(resourceGroup().id)}'
//param protectedName1 string = 'prtAdmin${uniqueString(resourceGroup().id)}'
//param protectedName2 string = 'prtWeb${uniqueString(resourceGroup().id)}'

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: recoveryvaultName
  location: location
  tags: tagValues
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {}
}

resource backupPolicies 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-12-01' = {
  parent: recoveryVault
  name: backupPoliciesName
  location: location
  tags: tagValues
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2022-03-08T08:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2022-03-08T08:00:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
    protectedItemsCount: 0
  }
}
