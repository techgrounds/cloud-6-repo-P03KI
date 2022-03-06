param clientVar object
param webVmId string

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2020-02-02' = {
  name: 'Recovery Vault'
  location: clientVar.location
  sku: {
    name: 'RS0'
  }
  properties: {}
}

resource bUpPol 'Microsoft.DataProtection/backupVaults/backupPolicies@2021-10-01-preview'{
  name: 'BackUpPolicy/'
  properties:{
    datasourceTypes: [
      webVmId
    ]
    objectType: 'BackupPolicy'
    policyRules:[
      {
        name: 'backup'
        dataStore: {
          dataStoreType: 'ArchiveStore'
          objectType:
        }
        objectType: 'AzureBackupRule'
        trigger: 
      }
    ]
  }
}

resource symbolicname 'Microsoft.RecoveryServices/vaults/backupPolicies@2019-05-13' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  parent: resourceSymbolicName
  eTag: 'string'
  properties: {
    protectedItemsCount: int
    backupManagementType: 'string'
    // For remaining properties, see ProtectionPolicy objects
  }
}

backupManagementType: 'AzureStorage'
  retentionPolicy: {
    retentionPolicyType: 'string'
    // For remaining properties, see RetentionPolicy objects
  }
  schedulePolicy: {
    schedulePolicyType: 'string'
    // For remaining properties, see SchedulePolicy objects
  }
  timeZone: 'string'
  workLoadType: 'string'
// resource vaultName_backupFabric_protectionContainer_protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2020-02-02' = {
//   name: '${Recovery Vault}/${backupFabric}/${protectionContainer}/${protectedItem}'
//   properties: {
//     protectedItemType: 'Microsoft.Compute/virtualMachines'
//     policyId: '${recoveryServicesVault.id}/backupPolicies/${backupPolicyName}'
//     sourceResourceId: webVmId
//   }
// } 
