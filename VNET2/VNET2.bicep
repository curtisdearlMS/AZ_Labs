param vnetName string = 'VNET2'
param privateEndpointSubnetName string = 'PrivateEndpointSubnet'
param vmSubnetName string = 'VMSubnet'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: privateEndpointSubnetName
        properties: {
          addressPrefix: '10.2.1.0/24'
          networkSecurityGroup: {
            id: nsgPrivateEndpointSubnet.id
          }
          routeTable: {
            id: rtPrivateEndpointSubnet.id
          }
        }
      }
      {
        name: vmSubnetName
        properties: {
          addressPrefix: '10.2.2.0/24'
          networkSecurityGroup: {
            id: nsgVMSubnet.id
          }
          routeTable: {
            id: rtVMSubnet.id
          }
        }
      }
    ]
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
    routes: []
  }
}

resource nsgVMSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgVMSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource rtVMSubnet 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnetName}-rtVMSubnet'
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
      {
        name: 'vnet1Route'
        properties: {
          addressPrefix: '10.0.0.0/15'// bigger than VNET 1 address space so that a direct peering will have a more specific route
          //this is used for traffic not routed to the firewall when a system route has a more specific route
          //nextHopType: 'VirtualNetworkGateway' // does work if the VNET GW is deploy, simpler to default to the Azure Firewall
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.28.15.4' // Azure Firewall private IP
        }
      }
    ]
  }
}
