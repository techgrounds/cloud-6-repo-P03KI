targetScope = 'resourceGroup'
param clientVar object ={
  location: 'westeurope'
}

resource getObjId 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'GetObjectId'
  location: clientVar.location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      //'/subscriptions/01234567-89AB-CDEF-0123-456789ABCDEF/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myID': {}
      '${subscription().id}' : {}
    }
  }
  properties: {
    //forceUpdateTag: '1'
    // containerSettings: {
    //   containerGroupName: 'mycustomaci'
    // }
    // storageAccountSettings: {
    //   storageAccountName: 'myStorageAccount'
    //   storageAccountKey: 'myKey'
    // }
    azPowerShellVersion: '6.4' // or azCliVersion: '2.28.0'
    arguments: '-name \\"John Dole\\"'
    environmentVariables: [
      {
        name: 'UserName'
        value: 'jdole'
      }
      {
        name: 'Password'
        secureValue: 'jDolePassword'
      }
    ]
    scriptContent: '''
    Function Get-Something {
      <#
      .SYNOPSIS
          This is a basic overview of what the script is used for..
       
       
      .NOTES
          Name: Get-Something
          Author: theSysadminChannel
          Version: 1.0
          DateCreated: 2020-Dec-10
       
       
      .EXAMPLE
          Get-Something -UserPrincipalName "username@thesysadminchannel.com"
       
       
      .LINK
          https://thesysadminchannel.com/powershell-template -
      #>
       
          [CmdletBinding()]
          param(
              [Parameter(
                  Mandatory = $false,
                  ValueFromPipeline = $true,
                  ValueFromPipelineByPropertyName = $true,
                  Position = 0
                  )]
              [string[]]  $UserPrincipalName
          )
       
          BEGIN {}
       
          PROCESS {}
       
          END {}
      }
      
      //param([string] $name)
      //$output = \'Hello {0}. The username is {1}, the password is {2}.\' -f $name,\${Env:UserName},\${Env:Password}
      $output = az ad signed-in-user show --query objectId
      Write-Output $output
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs[\'text\'] = $output
    ''' // or primaryScriptUri: 'https://raw.githubusercontent.com/Azure/azure-docs-bicep-samples/main/samples/deployment-script/inlineScript.ps1'
    //supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}
