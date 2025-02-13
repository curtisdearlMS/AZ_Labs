param location string
param resourceGroupName string = 'Azure Networking Training Lab'
param vpnGatewaySku string

param vnetName string = 'HUB VNET'
param firewallName string = 'myAzureFirewall'
param vpnGatewayName string = 'myVpnGateway'
param publicIpFirewallName string = 'fwPublicIP'
param publicIpVpnGwName string = 'vpnGwPublicIP'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.12.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '172.12.0.0/24'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '172.12.1.0/24'
        }
      }
      {
        name: 'PrivateEndpointSubnet'
        properties: {
          addressPrefix: '172.12.2.0/24'
        }
      }
      {
        name: 'VirtualMachineSubnet'
        properties: {
          addressPrefix: '172.12.3.0/24'
        }
      }
    ]
  }
}

resource publicIpFirewall 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpFirewallName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'firewallIPConfig'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: publicIpFirewall.id
          }
        }
      }
    ]
  }
  dependsOn: [
    publicIpFirewall
    vnet
  ]
}

resource publicIpVpnGw 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpVpnGwName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: publicIpVpnGw.id
          }
        }
      }
    ]
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    sku: vpnGatewaySku
  }
  dependsOn: [
    vnet
    publicIpVpnGw
  ]
}
