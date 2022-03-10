param kvVar object
param clientVar object
param recVltName string
param tags object
var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${admvm.name}'
var protectedItem = 'vm;iaasvmcontainerv2;${resourceGroup().name};${admvm.name}'
var protectionContainer2 = 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${webvm.name}'
var protectedItem2 = 'vm;iaasvmcontainerv2;${resourceGroup().name};${webvm.name}'

resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: clientVar.client
}
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
  identity:{
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}' : {}
    }
  }
  properties:{
    // ------------  deploy account limitation --------------
    // encryption:{
    //   keyVaultProperties:{
    //     keyUri: kv.properties.vaultUri
    //   }
    // }
  }
}

resource backuppolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2021-12-01' = {
  name: 'backuppolicy'
  parent: recoveryvault
  tags: tags
  properties: {
    backupManagementType: 'AzureIaasVM'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2022-03-10T00:30:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2022-03-10T00:30:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 3
    timeZone: 'W. Europe Standard Time'
  }
}

resource backupWeb 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recVltName}/${backupFabric}/${protectionContainer2}/${protectedItem2}'
  tags: tags
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backuppolicy.id
    sourceResourceId: webvm.id
  }
}

resource backupAdmin 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2021-12-01' = {
  name: '${recoveryvault.name}/${backupFabric}/${protectionContainer}/${protectedItem}'
  tags: tags
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backuppolicy.id
    sourceResourceId: admvm.id
  }
   dependsOn:[
   backupWeb
   ]
} 
