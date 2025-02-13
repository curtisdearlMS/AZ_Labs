param resourceGroupName string = 'Azure_Networking_Training_Lab'
param vpnGatewaySku string

param vnetName string = 'Hub_VNET_172_12_0_0_16'
param firewallName string = 'myAzureFirewall'
param vpnGatewayName string = 'myVpnGateway'
param publicIpFirewallName string = 'fwPublicIP'
param publicIpVpnGwName string = 'vpnGwPublicIP'

resource nsgAzureFirewallSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsgAzureFirewallSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      // Define security rules here
    ]
  }
}

resource rtAzureFirewallSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rtAzureFirewallSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      // Define routes here
    ]
  }
}

resource nsgGatewaySubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsgGatewaySubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      // Define security rules here
    ]
  }
}

resource rtGatewaySubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rtGatewaySubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      // Define routes here
    ]
  }
}

resource nsgPrivateEndpointSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsgPrivateEndpointSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      // Define security rules here
    ]
  }
}

resource rtPrivateEndpointSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rtPrivateEndpointSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      // Define routes here
    ]
  }
}

resource nsgVirtualMachineSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsgVirtualMachineSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      // Define security rules here
    ]
  }
}

resource rtVirtualMachineSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rtVirtualMachineSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      // Define routes here
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: resourceGroup().location
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
          networkSecurityGroup: {
            id: nsgAzureFirewallSubnet.id
          }
          routeTable: {
            id: rtAzureFirewallSubnet.id
          }
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '172.12.1.0/24'
          networkSecurityGroup: {
            id: nsgGatewaySubnet.id
          }
          routeTable: {
            id: rtGatewaySubnet.id
          }
        }
      }
      {
        name: 'PrivateEndpointSubnet'
        properties: {
          addressPrefix: '172.12.2.0/24'
          networkSecurityGroup: {
            id: nsgPrivateEndpointSubnet.id
          }
          routeTable: {
            id: rtPrivateEndpointSubnet.id
          }
        }
      }
      {
        name: 'VirtualMachineSubnet'
        properties: {
          addressPrefix: '172.12.3.0/24'
          networkSecurityGroup: {
            id: nsgVirtualMachineSubnet.id
          }
          routeTable: {
            id: rtVirtualMachineSubnet.id
          }
        }
      }
    ]
  }
  dependsOn: [
    nsgAzureFirewallSubnet
    rtAzureFirewallSubnet
    nsgGatewaySubnet
    rtGatewaySubnet
    nsgPrivateEndpointSubnet
    rtPrivateEndpointSubnet
    nsgVirtualMachineSubnet
    rtVirtualMachineSubnet
  ]
}

resource publicIpFirewall 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpFirewallName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  dependsOn: [
    vnet
  ]
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: resourceGroup().location
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
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  dependsOn: [
    vnet
  ]
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: vpnGatewayName
  location: resourceGroup().location
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
