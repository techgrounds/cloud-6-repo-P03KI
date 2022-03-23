param applicationGateways_appGateway_name string = 'appGateway'
param virtualNetworks_app_prd_vnet_externalid string = '/subscriptions/1168811b-be55-443f-ad5d-bd1676feeb9e/resourceGroups/rx4/providers/Microsoft.Network/virtualNetworks/app-prd-vnet'
param publicIPAddresses_pubIp_web_externalid string = '/subscriptions/1168811b-be55-443f-ad5d-bd1676feeb9e/resourceGroups/rx4/providers/Microsoft.Network/publicIPAddresses/pubIp-web'

resource applicationGateways_appGateway_name_resource 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGateways_appGateway_name
  location: 'westeurope'
  tags: {
    Client: 'XYZ'
    Version: '1.1.1'
    Environment: 'Dev'
  }
  zones: [
    '1'
  ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/1168811b-be55-443f-ad5d-bd1676feeb9e/resourcegroups/rx4/providers/Microsoft.ManagedIdentity/userAssignedIdentities/XYZ': {}
    }
  }
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: '${applicationGateways_appGateway_name}IpConfig'
        properties: {
          subnet: {
            id: '${virtualNetworks_app_prd_vnet_externalid}/subnets/subnetGW'
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: '${applicationGateways_appGateway_name}SslCert'
        properties: {
          keyVaultSecretId: 'https://kvxyz42439.vault.azure.net/secrets/SSLcert'
        }
      }
    ]
    trustedRootCertificates: [
      {
        name: 'SSL'
        properties: {
          data: 'MIIDADCCAeigAwIBAgIQHsnh1Yc7Ja9MB+6rohvydjANBgkqhkiG9w0BAQUFADATMREwDwYDVQQDDAhTU0xEVU1NWTAeFw0yMjAzMjExNDQ4NDJaFw0yNDAzMjExNDU4NDNaMBMxETAPBgNVBAMMCFNTTERVTU1ZMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr78RYb0bv3rSlIy87i866NkFbE5eaD7DysFAB/bCTL8PmHIOdu+5Mq9pituvhXKsKWaICGNJyOwYI2HUZk5e/Bm79+oYjwIH0l/PLeMX4MVeyw663u2kYQoFrsrlDndMpDlQ/J6XG2Bb2Q0k4M/KgQvCsmocUYzc5AkhPlUWqIpoH4tOsVlnqVaajkZ7pe8p/GcxsytxoL0wX6DZdxfiMGIgerzg6geCggCEp0rRQcThHydJ5m06n01CGzhHW7s4Ri2K6+PMtZY+wiVPfuSzyY6luhEhmbGUoaKtSjWGMwCjGX1HWev6gllY9EHasgg/Y+Us3Iz2AcxUB9B8VFOCkQIDAQABo1AwTjAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMB0GA1UdDgQWBBTSxTVfo9qhuxmJx2+qEGvMLwZDZjANBgkqhkiG9w0BAQUFAAOCAQEAmuDDZVVJf6l2uC8rTsVeoEOWrnlIQ0Ndtqp9Ow9ezHMfOvXx7CVEtcAiydYVDFURaF6qyDsrY8s7XUsNLlnfcx3BBnvTgmabRW5793jUvFBHAwmQWoOr9I1dz0kTeVTXukCbu7lbH1Ehq7eiGasLVJg+3VFYaqTJKf5bb1SzaY7SfTdOgKK5/jdPAnVlVXQhUNl48Yb01ammD/1C3jBvVOjB00e3fs9/7f+xDTsyUelf/mX//VX7b3+UK7xHV/XXIHGm1ZwTlCECRhQXaoKCIe4O4CsZ0Oxt0b988wvqigycpMGuadAn9E9l5fGC4hD0rm6NO+gVnieXjzj+da9idA=='
        }
      }
    ]
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: '${applicationGateways_appGateway_name}FrontendIP'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pubIp_web_externalid
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: '${applicationGateways_appGateway_name}FrontendPort80'
        properties: {
          port: 80
        }
      }
      {
        name: '${applicationGateways_appGateway_name}FrontendPort443'
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bePool'
        properties: {
          backendAddresses: []
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'HTTPbe'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 30
          probe: {
            id: '${applicationGateways_appGateway_name_resource.id}/probes/hpOrb2SS1'
          }
        }
      }
      {
        name: 'HTTPSbe'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 30
          probe: {
            id: '${applicationGateways_appGateway_name_resource.id}/probes/hpOrb2SS2'
          }
          trustedRootCertificates: [
            {
              id: '${applicationGateways_appGateway_name_resource.id}/trustedRootCertificates/SSL'
            }
          ]
        }
      }
    ]
    httpListeners: [
      {
        name: 'WEB80l'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_appGateway_name_resource.id}/frontendIPConfigurations/${applicationGateways_appGateway_name}FrontendIP'
          }
          frontendPort: {
            id: '${applicationGateways_appGateway_name_resource.id}/frontendPorts/${applicationGateways_appGateway_name}FrontendPort80'
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
        }
      }
      {
        name: 'SSL443l'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGateways_appGateway_name_resource.id}/frontendIPConfigurations/${applicationGateways_appGateway_name}FrontendIP'
          }
          frontendPort: {
            id: '${applicationGateways_appGateway_name_resource.id}/frontendPorts/${applicationGateways_appGateway_name}FrontendPort443'
          }
          protocol: 'Https'
          sslCertificate: {
            id: '${applicationGateways_appGateway_name_resource.id}/sslCertificates/${applicationGateways_appGateway_name}SslCert'
          }
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: 'WEB80r'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGateways_appGateway_name_resource.id}/httpListeners/WEB80l'
          }
          redirectConfiguration: {
            id: '${applicationGateways_appGateway_name_resource.id}/redirectConfigurations/WEB80r'
          }
        }
      }
      {
        name: 'SSL443r'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGateways_appGateway_name_resource.id}/httpListeners/SSL443l'
          }
          backendAddressPool: {
            id: '${applicationGateways_appGateway_name_resource.id}/backendAddressPools/bePool'
          }
          backendHttpSettings: {
            id: '${applicationGateways_appGateway_name_resource.id}/backendHttpSettingsCollection/HTTPbe'
          }
        }
      }
    ]
    probes: [
      {
        name: 'hpOrb2SS1'
        properties: {
          protocol: 'Http'
          host: '127.0.0.1'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {}
        }
      }
      {
        name: 'hpOrb2SS2'
        properties: {
          protocol: 'Https'
          host: '127.0.0.1'
          path: '/'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: false
          minServers: 0
          match: {}
        }
      }
    ]
    rewriteRuleSets: []
    redirectConfigurations: [
      {
        name: 'WEB80r'
        properties: {
          redirectType: 'Permanent'
          targetListener: {
            id: '${applicationGateways_appGateway_name_resource.id}/httpListeners/SSL443l'
          }
          includePath: true
          includeQueryString: true
          requestRoutingRules: [
            {
              id: '${applicationGateways_appGateway_name_resource.id}/requestRoutingRules/WEB80r'
            }
          ]
        }
      }
    ]
    privateLinkConfigurations: []
    sslPolicy: {
      policyType: 'Custom'
      minProtocolVersion: 'TLSv1_2'
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
    autoscaleConfiguration: {
      minCapacity: 1
      maxCapacity: 3
    }
  }
}