var vnetName = 'HubVNET'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.28.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.28.15.0/24'
          routeTable: {
            id: rtAzureFirewallSubnet.id
          }
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.28.1.0/24'
          routeTable: {
            id: rtGatewaySubnet.id
          }
        }
      }
      {
        name: 'PrivateEndpointSubnet'
        properties: {
          addressPrefix: '10.28.2.0/24'
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
          addressPrefix: '10.28.3.0/24'
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
}

resource nsgAzureFirewallSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgAzureFirewallSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource rtAzureFirewallSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnetName}-rtAzureFirewallSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource nsgGatewaySubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgGatewaySubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource rtGatewaySubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnetName}-rtGatewaySubnet'
  location: resourceGroup().location
  properties: {
    routes: []
  }
}

resource nsgPrivateEndpointSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgPrivateEndpointSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource rtPrivateEndpointSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnetName}-rtPrivateEndpointSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource nsgVirtualMachineSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgVirtualMachineSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource rtVirtualMachineSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnetName}-rtVirtualMachineSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.28.15.4' // Azure Firewall private IP
        }
      }
    ]
  }
}

output vnetId string = vnet.id
