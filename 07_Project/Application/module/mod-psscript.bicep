targetScope = 'resourceGroup'
param vnetVar object
param tags object
param clientVar object
param stgType string
param stgName string
// var bootstrapRoleAssignmentId = guid('${resourceGroup().id}contributor')
// var contributorRoleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: clientVar.client
  location: clientVar.location
  tags:tags
}

resource vnet0 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[0]
}
resource vnet1 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetVar.vnetName[1]
}
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
//   name: bootstrapRoleAssignmentId
//   properties: {
//     roleDefinitionId: contributorRoleDefinitionId
//     principalId: reference(mngId.id, '2018-11-30').principalId
//     scope: resourceGroup().id
//     principalType: 'ServicePrincipal'
//   }
// }

resource getObjIdScr 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'GetObjectId'
  location: clientVar.location
  //tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mngId.id}' : {}
    }
  }
  properties: {
    azPowerShellVersion: '7.2.1'
    //arguments: 
    //azCliVersion: '2.28.0'
    // scriptContent: '''
    // $output = az ad signed-in-user show --query objectId
    // Write-Output $output
    // $DeploymentScriptOutputs = @{}
    // $DeploymentScriptOutputs['objId'] = $output
    // '''
    primaryScriptUri: './etc/PS-Script1.ps1'
    timeout: 'PT05M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

output objId string = getObjIdScr.properties.outputs.text
output mngId string = mngId.id

// $output = az ad signed-in-user show --query objectId
// Write-Output $output
// $DeploymentScriptOutputs = @{}
// $DeploymentScriptOutputs['objid'] = $output
