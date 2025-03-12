var peSubnetName = 'PrivateEndpointSubnet'
var peSubnetAddressPrefix = '10.28.2.0/24' // why is this hardcoded and not a referernce 
var firewallIp = '10.28.15.4'


resource hubVnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'hubvnet'
}

resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet1'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet2'
}

resource peSubnetPolicy 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: hubVnet
  name: peSubnetName
  properties: {
    addressPrefix: peSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
  }
}

resource routeTableVnet1 'Microsoft.Network/routeTables@2021-02-01' = {
  name: '${vnet1.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'routeToPESubnet'
        properties: {
          addressPrefix: peSubnetAddressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.28.15.4' // Azure Firewall private IP
        }
      }
      {
        name: 'vnet2Route'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualNetworkGateway'
        }
      }
    ]
  }
}

resource routeTableVnet2 'Microsoft.Network/routeTables@2021-02-01' = {
  name: '${vnet2.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'routeToPESubnet'
        properties: {
          addressPrefix: peSubnetAddressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallIp
        }
      }
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
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualNetworkGateway'
        }
      }
    ]
  }
}
