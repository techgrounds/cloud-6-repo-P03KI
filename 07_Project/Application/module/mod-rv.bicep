param clientVar object
param webVmId string
param admVmId string
param kvUri string
param tags object
var backupFabric = 'Azure'
var protectionContainer1 = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};Admin-Server'
var protectedItem1 = 'vm;iaasvmcontainerv2;${resourceGroup().name};Admin-Server'
var protectionContainer2 = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};Web-Server'
var protectedItem2 = 'vm;iaasvmcontainerv2;${resourceGroup().name};Web-Server'

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2021-08-01' = {
  name: 'RecoveryVault'
  location: clientVar.location
  tags:tags
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    encryption:{
      keyVaultProperties:{
        keyUri: kvUri
      }
    }
  }
}

resource backupLinux 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recoveryServicesVault}/${backupFabric}/${protectionContainer1}/${protectedItem1}'
  tags:tags
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backupPolicy.id
    sourceResourceId: webVmId
  }
} 
resource backupWindows 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recoveryServicesVault}/${backupFabric}/${protectionContainer2}/${protectedItem2}'
  tags:tags
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backupPolicy.id
    sourceResourceId: admVmId
  }
}
resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2019-05-13' = {
  name: 'BackupPolicy'
  location: clientVar.location
  parent: recoveryServicesVault
  properties: {
    protectedItemsCount: 2
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays: 7
  retentionPolicy: {
    retentionPolicyType: 'SimpleRetentionPolicy'
    retentionDuration:{
      count: 7
      durationType: 'Days'
    }
  }
  schedulePolicy: {
    schedulePolicyType: 'SimpleSchedulePolicy'
    scheduleRunFrequency:'Daily'
    scheduleRunTimes:[
      '01:00'
    ]
  }
  timeZone: 'UTC'
  }
}
