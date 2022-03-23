param kvVar object
param tags object

resource kv 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: kvVar.kvName
  location: kvVar.location
  tags:tags
  properties:{
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableRbacAuthorization: false
    tenantId:  kvVar.tenantId
    ////////// Temporary for testdeployments ///////////////////////
    enablePurgeProtection: true
    enableSoftDelete: true
    //////////////////////////////////////////////////////////////
    accessPolicies:[
      {
        objectId: kvVar.objectId
        tenantId: kvVar.tenantId
        permissions:{
          keys:[
            'all'
          ]
          secrets:[
            'all'
          ]
          storage:[
            'all'
          ]
          certificates:[
            'all'
          ]
        }
      }
    ]
    sku:{
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    //   virtualNetworkRules:[
    //     {
    //         id: '${vnet[0].id}/subnets/subnet1'
    //     }       
    //     {
    //         id: '${vnet[1].id}/subnets/subnet2'      
    //     }
    // ]
    }
  }
}
