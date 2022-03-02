//----------- Scope --------------
targetScope = 'subscription'
//------------ VAR ---------------
param rgName string
param location string
//---------------  Make RG -----------------------------------------------
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}
