targetScope = 'resourceGroup'

param tags object
param clientVar object
// var bootstrapRoleAssignmentId = guid('${resourceGroup().id}contributor')
// var contributorRoleDefinitionId = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: clientVar.client
  location: clientVar.location
  tags:tags
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

resource getObjId 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'GetObjectId'
  location: clientVar.location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mngId.id}' : {}
    }
  }
  properties: {
    azPowerShellVersion: '6.4'
    //azCliVersion: '2.28.0'
    scriptContent: '''
    $output = az ad signed-in-user show --query objectId
    Write-Output $output
    $DeploymentScriptOutputs = @{}
    $DeploymentScriptOutputs['text'] = $output
    '''
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}
output scriptLogs string = reference('${getObjId.id}/logs/default', getObjId.apiVersion, 'Full').properties.log
//output objId string = getObjId.properties.outputs['output']
output mngId string = mngId.id
