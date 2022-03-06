//----------- Scope --------------
targetScope = 'subscription'

//------------ VAR ---------------
param clientVar object

//---------------  Make RG -----------------------------------------------
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: clientVar.rgName
  location: clientVar.location
}
