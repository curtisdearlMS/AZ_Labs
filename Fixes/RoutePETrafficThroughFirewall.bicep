param hubVnetName string = 'HubVNET'
param hubPeSubnetName string = 'PrivateEndpointSubnet'
param vnet1Name string = 'VNET1'
param vnet1VmSubnetName string = 'VMSubnet'
param vnet2Name string = 'VNET2'
param vnet2VmSubnetName string = 'VMSubnet'
resource firewall 'Microsoft.Network/azureFirewalls@2023-05-01' existing = {
  name: 'yourFirewallName'
  scope: resourceGroup('yourResourceGroupName')
}

var firewallPrivateIp = firewall.properties.ipConfigurations[0].properties.privateIPAddress

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' existing = {
  name: hubVnetName
}

resource hubPeSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' existing = {
  name: hubPeSubnetName
  parent: hubVnet
}

resource hubPeSubnetRouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: '${hubVnetName}-${hubPeSubnetName}-rt'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'RouteToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

resource vnet1VmSubnetRouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: '${vnet1Name}-${vnet1VmSubnetName}-rt'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'RouteToHubPeSubnet'
        properties: {
          addressPrefix: hubPeSubnet.properties.addressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

resource vnet2VmSubnetRouteTable 'Microsoft.Network/routeTables@2023-05-01' = {
  name: '${vnet2Name}-${vnet2VmSubnetName}-rt'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'RouteToHubPeSubnet'
        properties: {
          addressPrefix: hubPeSubnet.properties.addressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}


