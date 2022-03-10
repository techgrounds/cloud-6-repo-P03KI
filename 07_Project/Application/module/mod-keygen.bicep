targetScope = 'resourceGroup'
param timestamp string = utcNow()

resource generatePassword 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'generatePassword-${timestamp}'
  location: resourceGroup().location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.0.77'
    retentionInterval: 'PT1H'
    forceUpdateTag: timestamp // script will run every time
    scriptContent: 'password=$( env LC_ALL=C tr -dc \'A-Za-z0-9!#%&()*+,-./:;<=>?@^_`{|}~\' </dev/urandom | head -c 41 ); json="{\\"password\\":\\"$password\\"}"; echo "$json" > "$AZ_SCRIPTS_OUTPUT_PATH";'
    cleanupPreference: 'Always'
  }
}

output password string = generatePassword.properties.outputs.password
