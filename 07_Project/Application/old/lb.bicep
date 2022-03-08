@description('Admin username')
param adminUsername string

@description('Admin password')
@secure()
param adminPassword string

@description('Unique DNS name')
param dnsNameforLBIP string = 'uniqueDnsNameforLBIP'

@description('VM name prefix')
param vmNamePrefix string = 'myVM'

@description('Load Balancer name')
param lbName string = 'myLB'

@description('Network Interface Name Prefix')
param nicNamePrefix string = 'nic'

@description('Public IP Address Name')
param publicIPAddressName string = 'myPublicIP'

@description('VNET name')
param vnetName string = 'myVNET'

@description('Image Publisher')
param imagePublisher string = 'MicrosoftWindowsServer'

@description('Image Offer')
param imageOffer string = 'WindowsServer'

@description('Image SKU')
param imageSKU string = '2012-R2-Datacenter'

@description('VM Size')
@allowed([
  'Standard_A0'
  'Standard_A1'
  'Standard_A2'
  'Standard_A3'
  'Standard_A4'
])
param vmSize string = 'Standard_A1'

@description('Resource location')
param location string = resourceGroup().location

var storageAccountType = 'Standard_LRS'
var availabilitySetName_var = 'myAvSet'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'Subnet-1'
var subnetPrefix = '10.0.0.0/24'
var publicIPAddressType = 'Dynamic'
var numberOfInstances = 2
var storageAccountName_var = uniqueString(resourceGroup().id)
var networkSecurityGroupName_var = '${subnetName}-nsg'

resource storageAccountName 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageAccountName_var
  location: location
  sku: {
    name: storageAccountType
  }
}

resource availabilitySetName 'Microsoft.Compute/availabilitySets@2016-04-30-preview' = {
  name: availabilitySetName_var
  location: location
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 2
    managed: true
  }
}

resource publicIPAddressName_resource 'Microsoft.Network/publicIPAddresses@2015-06-15' = {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: dnsNameforLBIP
    }
  }
}

resource networkSecurityGroupName 'Microsoft.Network/networkSecurityGroups@2019-08-01' = {
  name: networkSecurityGroupName_var
  location: location
  properties: {}
}

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2015-06-15' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroupName.id
          }
        }
      }
    ]
  }
}

resource nicNamePrefix_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0, numberOfInstances): {
  name: concat(nicNamePrefix, i)
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, 'LoadBalancerBackend')
            }
          ]
          loadBalancerInboundNatRules: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/inboundNatRules', lbName, 'RDP-VM${i}')
            }
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnetName_resource
    lbName_resource
    resourceId('Microsoft.Network/loadBalancers/inboundNatRules', lbName, 'RDP-VM${i}')
  ]
}]

resource lbName_resource 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: lbName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerFrontend'
        properties: {
          publicIPAddress: {
            id: publicIPAddressName_resource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'LoadBalancerBackend'
      }
    ]
  }
}

resource lbName_RDP_VM 'Microsoft.Network/loadBalancers/inboundNatRules@2020-11-01' = [for i in range(0, numberOfInstances): {
  name: '${lbName}/RDP-VM${i}'
  location: location
  properties: {
    frontendIPConfiguration: {
      id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, 'loadBalancerFrontend')
    }
    protocol: 'Tcp'
    frontendPort: (i + 5000)
    backendPort: 3389
    enableFloatingIP: false
  }
  dependsOn: [
    lbName_resource
  ]
}]

resource vmNamePrefix_resource 'Microsoft.Compute/virtualMachines@2020-12-01' = [for i in range(0, numberOfInstances): {
  name: concat(vmNamePrefix, i)
  location: location
  properties: {
    availabilitySet: {
      id: availabilitySetName.id
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: concat(vmNamePrefix, i)
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSKU
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', concat(nicNamePrefix, i))
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(storageAccountName_var, '2021-01-01').primaryEndpoints.blob
      }
    }
  }
  dependsOn: [
    storageAccountName
    resourceId('Microsoft.Network/networkInterfaces', concat(nicNamePrefix, i))
    availabilitySetName
  ]
}]