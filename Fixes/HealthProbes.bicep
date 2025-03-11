// Description: This Bicep template modifies the health probe to use port 22.
var publicLoadBalancer_Name  = 'VNET1_Ext_VM_LB'
var protocol  = 'TCP'
var frontendPort  = 80
var backendPort  = 80
var enableTcpReset = false
var enableFloatingIP = false

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: '${publicLoadBalancer_Name}_PIP'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2024-01-01' = {
  name: publicLoadBalancer_Name
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'fip'
        properties: {
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bep'
      }
    ]
    loadBalancingRules: [
      {
        name: 'inboundRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', publicLoadBalancer_Name, 'fip')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', publicLoadBalancer_Name, 'bep')
          }
          disableOutboundSnat: true // must be set to true when using the same fip for outbound and inbound rules
          protocol: protocol
          frontendPort: frontendPort
          backendPort: backendPort
          enableFloatingIP: enableFloatingIP
          idleTimeoutInMinutes: 4
          enableTcpReset: enableTcpReset
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', publicLoadBalancer_Name, 'port80healthprobe')
          }
        }
      }
    ]
    outboundRules: [
      {
        name: 'outboundRule'
        properties: {
          frontendIPConfigurations: [
             {
              id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', publicLoadBalancer_Name, 'fip')
             }
          ]
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', publicLoadBalancer_Name, 'bep')
          }
          protocol: 'All'
          idleTimeoutInMinutes: 4
          enableTcpReset: enableTcpReset
          allocatedOutboundPorts: 30000
        }
      }
    ]
    probes: [
      {
        name: 'port80healthprobe'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
        }
      }
    ]
  }
}
