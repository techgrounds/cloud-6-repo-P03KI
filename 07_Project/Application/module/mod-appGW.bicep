param vnetVar object
param clientVar object
param agw string = 'appGateway'
param tags object
param kvVar object
param bePool string = 'bePool'

resource mngId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: clientVar.client
}
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: { 
  name: 'pubIp-${vnetVar.environment[i]}'
}]
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = [for (vnetName, i) in vnetVar.vnetName: {
  name: vnetVar.vnetName[i]
}]
resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: kvVar.kvName
}

//////////////////////////////// AGW Subnet  /////////////////////////////////////////////////////
resource subnetGW 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'subnetGW'
  parent: vnet[0]
  properties: {
    networkSecurityGroup:{
      id: nsg1.id
    }
    addressPrefix: vnetVar.snet2Prefix[0]
    privateEndpointNetworkPolicies: 'Enabled'
    serviceEndpoints: [
      { 
        service: 'Microsoft.KeyVault'
      }
      {  
        service: 'Microsoft.Storage'
      }
    ]
  }        
}
resource nsg1 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-${vnetVar.environment[0]}'
  location: clientVar.location
  tags:tags
  properties: {
    securityRules: [
        {
        name: 'HTTP'
        properties: {
          description: 'HTTP-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 700
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTPS'
        properties: {
          description: 'HTTPS-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
        }
      }
      {
        name: 'rdp'
        properties: {
          description: 'rdp-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
      {
        name: 'ssh'
        properties: {
          description: 'ssh-rule'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
      {
        name: 'GatewayManager'
        properties: {
          description: 'GatewayManager'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

///////////////////////////////  Application gateway (Load Balancer) //////////////////////////////
resource appGateway 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: agw
  location: clientVar.location
  tags: tags
  zones:[
    '1'
  ]
  identity:{
    type:'UserAssigned'
    userAssignedIdentities:{
      '${mngId.id}':{}
    }
  }
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    probes:[
      {
        name: 'hpOrb2SS1'
        properties:{
          protocol:'Http'
          host: '127.0.0.1'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
        }
      }
      {
        name: 'hpOrb2SS2'
        properties:{
          protocol:'Https'
          host: '127.0.0.1'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
        }
      }
    ]
    sslCertificates:[
      {
        name: 'appGatewaySslCert'
        properties:{
          keyVaultSecretId: '${kv.properties.vaultUri}secrets/SSLcert'
        }
      }
    ]
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 3
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetGW.id
          }
        }
      }
    ]
    sslPolicy:{
      policyType: 'Custom'
      minProtocolVersion:'TLSv1_2'
      cipherSuites: [
        'TLS_RSA_WITH_AES_256_CBC_SHA256'
        'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
        'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
        'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
        'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256'
        'TLS_RSA_WITH_AES_128_GCM_SHA256'
        'TLS_RSA_WITH_AES_128_CBC_SHA256'
      ]
    }
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIP'
        properties: {
          publicIPAddress: {
            id: pubIp[0].id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort80'
        properties: {
          port: 80
        }
      }
      {
        name: 'appGatewayFrontendPort443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: bePool
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'HTTPbe'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          probeEnabled: true
          probe:{
            id: resourceId('Microsoft.Network/applicationGateways/probes', agw, 'hpOrb2SS1')
          }
        }
      }
      {
        name: 'HTTPSbe'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          probeEnabled: true
          probe:{
            id: resourceId('Microsoft.Network/applicationGateways/probes', agw, 'hpOrb2SS2')
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'WEB80l'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', agw, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', agw, 'appGatewayFrontendPort80')
          }
          protocol: 'Http'
        }
      }
      {
        name: 'SSL443l'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', agw, 'appGatewayFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', agw, 'appGatewayFrontendPort443')
          }
          protocol: 'Https'
          sslCertificate:{
            id:  resourceId('Microsoft.Network/applicationGateways/sslCertificates', agw, 'appGatewaySslCert')
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'WEB80r'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', agw, 'WEB80l')
          }
          redirectConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations/', agw, 'WEB80red')
          }
        }
      }
      {
        name: 'SSL443r'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', agw, 'SSL443l')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', agw, bePool)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', agw, 'HTTPbe')
          }
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 'WEB80red'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', agw, 'SSL443l')
          }
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/requestRoutingRules', agw, 'WEB80r')
            }
          ]
        }
      }
    ]
  }
}
