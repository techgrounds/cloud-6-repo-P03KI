@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string 

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints

// ---------------------------------- Properties -------------------------------------
//
// resource symbolicname 'Microsoft.Storage/storageAccounts@2021-08-01' = {
//   name: 'string'
//   location: 'string'
//   tags: {
//     tagName1: 'tagValue1'
//     tagName2: 'tagValue2'
//   }
//   sku: {
//     name: 'string'
//   }
//   kind: 'string'
//   extendedLocation: {
//     name: 'string'
//     type: 'EdgeZone'
//   }
//   identity: {
//     type: 'string'
//     userAssignedIdentities: {}
//   }
//   properties: {
//     accessTier: 'string'
//     allowBlobPublicAccess: bool
//     allowCrossTenantReplication: bool
//     allowedCopyScope: 'string'
//     allowSharedKeyAccess: bool
//     azureFilesIdentityBasedAuthentication: {
//       activeDirectoryProperties: {
//         accountType: 'string'
//         azureStorageSid: 'string'
//         domainGuid: 'string'
//         domainName: 'string'
//         domainSid: 'string'
//         forestName: 'string'
//         netBiosDomainName: 'string'
//         samAccountName: 'string'
//       }
//       defaultSharePermission: 'string'
//       directoryServiceOptions: 'string'
//     }
//     customDomain: {
//       name: 'string'
//       useSubDomainName: bool
//     }
//     defaultToOAuthAuthentication: bool
//     encryption: {
//       identity: {
//         federatedIdentityClientId: 'string'
//         userAssignedIdentity: 'string'
//       }
//       keySource: 'string'
//       keyvaultproperties: {
//         keyname: 'string'
//         keyvaulturi: 'string'
//         keyversion: 'string'
//       }
//       requireInfrastructureEncryption: bool
//       services: {
//         blob: {
//           enabled: bool
//           keyType: 'string'
//         }
//         file: {
//           enabled: bool
//           keyType: 'string'
//         }
//         queue: {
//           enabled: bool
//           keyType: 'string'
//         }
//         table: {
//           enabled: bool
//           keyType: 'string'
//         }
//       }
//     }
//     immutableStorageWithVersioning: {
//       enabled: bool
//       immutabilityPolicy: {
//         allowProtectedAppendWrites: bool
//         immutabilityPeriodSinceCreationInDays: int
//         state: 'string'
//       }
//     }
//     isHnsEnabled: bool
//     isLocalUserEnabled: bool
//     isNfsV3Enabled: bool
//     isSftpEnabled: bool
//     keyPolicy: {
//       keyExpirationPeriodInDays: int
//     }
//     largeFileSharesState: 'string'
//     minimumTlsVersion: 'string'
//     networkAcls: {
//       bypass: 'string'
//       defaultAction: 'string'
//       ipRules: [
//         {
//           action: 'Allow'
//           value: 'string'
//         }
//       ]
//       resourceAccessRules: [
//         {
//           resourceId: 'string'
//           tenantId: 'string'
//         }
//       ]
//       virtualNetworkRules: [
//         {
//           action: 'Allow'
//           id: 'string'
//           state: 'string'
//         }
//       ]
//     }
//     publicNetworkAccess: 'string'
//     routingPreference: {
//       publishInternetEndpoints: bool
//       publishMicrosoftEndpoints: bool
//       routingChoice: 'string'
//     }
//     sasPolicy: {
//       expirationAction: 'Log'
//       sasExpirationPeriod: 'string'
//     }
//     supportsHttpsTrafficOnly: bool
//   }
// }
