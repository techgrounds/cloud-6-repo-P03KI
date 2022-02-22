resource stg 'Microsoft.Storage/storageAccounts@2021-08-01' ={
  name: 'sdsds'
  location: 'westeurope'
  kind: 'Storage'
  sku:{
    name: 'Premium_LRS'
  }
}
