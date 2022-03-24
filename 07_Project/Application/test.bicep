param location string
param storageAccountName string
param accountType string
param kind string
param accessTier string
param minimumTlsVersion string
param supportsHttpsTrafficOnly bool
param allowBlobPublicAccess bool
param allowSharedKeyAccess bool
param allowCrossTenantReplication bool
param defaultOAuth bool
param networkAclsBypass string
param networkAclsDefaultAction string
param keySource string
param encryptionEnabled bool
param keyTypeForTableAndQueueEncryption string
param infrastructureEncryptionEnabled bool
param keyName string
param keyvaultUri string
param userAssignedIdentity string
param accountMSIType string
param accountUserAssignedIdentities array
param isContainerRestoreEnabled bool
param containerRestorePeriodDays int
param isBlobSoftDeleteEnabled bool
param blobSoftDeleteRetentionDays int
param isContainerSoftDeleteEnabled bool
param containerSoftDeleteRetentionDays int
param changeFeed bool
param isVersioningEnabled bool
param isShareSoftDeleteEnabled bool
param shareSoftDeleteRetentionDays int

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  properties: {
    accessTier: accessTier
    minimumTlsVersion: minimumTlsVersion
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    defaultToOAuthAuthentication: defaultOAuth
    networkAcls: {
      bypass: networkAclsBypass
      defaultAction: networkAclsDefaultAction
      ipRules: []
    }
    encryption: {
      keySource: keySource
      services: {
        blob: {
          enabled: encryptionEnabled
        }
        file: {
          enabled: encryptionEnabled
        }
        table: {
          enabled: encryptionEnabled
        }
        queue: {
          enabled: encryptionEnabled
        }
      }
      requireInfrastructureEncryption: infrastructureEncryptionEnabled
      keyvaultproperties: {
        keyname: keyName
        keyvaulturi: keyvaultUri
      }
      identity: {
        userAssignedIdentity: userAssignedIdentity
      }
    }
  }
  sku: {
    name: accountType
  }
  kind: kind
  identity: {
    type: accountMSIType
    userAssignedIdentities: {
      '${accountUserAssignedIdentities[0]}': {}
    }
  }
  tags: {}
  dependsOn: []
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  parent: storageAccountName_resource
  name: 'default'
  properties: {
    restorePolicy: {
      enabled: isContainerRestoreEnabled
      days: containerRestorePeriodDays
    }
    deleteRetentionPolicy: {
      enabled: isBlobSoftDeleteEnabled
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: isContainerSoftDeleteEnabled
      days: containerSoftDeleteRetentionDays
    }
    changeFeed: {
      enabled: changeFeed
    }
    isVersioningEnabled: isVersioningEnabled
  }
}

resource Microsoft_Storage_storageAccounts_fileservices_storageAccountName_default 'Microsoft.Storage/storageAccounts/fileservices@2021-08-01' = {
  parent: storageAccountName_resource
  name: 'default'
  properties: {
    shareDeleteRetentionPolicy: {
      enabled: isShareSoftDeleteEnabled
      days: shareSoftDeleteRetentionDays
    }
  }
  dependsOn: [
    storageAccountName_default
  ]
}