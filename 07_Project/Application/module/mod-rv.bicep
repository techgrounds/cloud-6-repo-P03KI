param kvVar object
param clientVar object
param recVltName string
param tags object
var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${admvm.name}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroup().name};${admvm.name}'
var protectionContainer2 = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${webvm.name}'
var protectedItem2 = 'vm;iaasvmcontainerv2;${resourceGroup().name};${webvm.name}'

resource webvm 'Microsoft.Compute/virtualMachines@2021-11-01' existing = {
  name: 'Web_Server'
}
resource admvm 'Microsoft.Compute/virtualMachines@2021-11-01' existing = {
  name: 'Admin_Server'
}
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
}
resource recoveryvault 'Microsoft.RecoveryServices/vaults@2021-11-01-preview' = {
  name: recVltName
  location: clientVar.location
  tags:tags
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties:{
    //// ------------  deploy account limitation --------------
    encryption:{
      keyVaultProperties:{
        keyUri: kv.properties.vaultUri
      }
    }
  }
}

resource backuppolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2019-05-13' = {
  name: 'backuppolicy'
  parent: recoveryvault
  properties: {
    backupManagementType: 'AzureIaasVM'
    instantRpRetentionRangeInDays:3
    retentionPolicy: {
      retentionPolicyType:'LongTermRetentionPolicy'
      dailySchedule:{
        retentionDuration:{
          count:7
          durationType:'Days'
        }
        retentionTimes:[
          '2022-03-01T01:30:00.00Z'
        ]
      }
    }
    schedulePolicy: {
      schedulePolicyType:'SimpleSchedulePolicy'
      scheduleRunFrequency:'Daily'
      scheduleRunTimes:[
        '2022-03-01T01:00:00.00Z'
      ]
      // scheduleWeeklyFrequency:0
      // scheduleRunDays:[
      //   'Friday'
      //   'Monday'
      //   'Saturday'
      //   'Sunday'
      //   'Thursday'
      //   'Tuesday'
      //   'Wednesday'
      // ]
  }
  timeZone: 'UTC'
  }
}

resource backupWeb 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recVltName}/${backupFabric}/${protectionContainer2}/${protectedItem2}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backuppolicy.id
    sourceResourceId: webvm.id
    // backupManagementType:'AzureIaasVM'
    // backupSetName: 'LinuxBackup'
    // containerName: 'LinuxBackup'
    // createMode:'Default'
    // workloadType:'VM'
  }
}

resource backupAdmin 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recoveryvault.name}/${backupFabric}/${protectionContainer}/${protectedItem}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backuppolicy.id
    sourceResourceId: admvm.id
  }
   dependsOn:[
   backupWeb
   ]
} 
