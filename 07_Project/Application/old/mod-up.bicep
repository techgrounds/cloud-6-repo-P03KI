@description('Name of the file as it is stored in the file share')
param filename string = 'install_apache.sh'
param utcValue string = utcNow()
param clientVar object
param stNameOutp string
param stKeyOutp string
param cont string
param fileShareName string = 'datashare'

module storage 'mod-stg.bicep' = {
  name: 'storageAccount'
  params: {
    deployFile: true
    entityName: fileShareName
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-ssh-${utcValue}'
  location: clientVar.location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: stNameOutp
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: stKeyOutp
      }
      {
        name: 'CONTENT'
        value: cont
      }
    ]
    scriptContent: 'echo "$CONTENT" > ${filename} && az storage file upload --source ${filename} -s ${fileShareName}'
  }
}
