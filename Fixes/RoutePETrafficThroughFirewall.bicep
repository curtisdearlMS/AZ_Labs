param hubVnetName string = 'hubvnet'
param peSubnetName string = 'PrivateEndpointSubnet'
param peSubnetAddressPrefix string = '10.28.2.0/24' // why is this hardcoded and not a referernce 
param firewallIp string = '10.28.15.4'
param vmSubnetName string = 'VMSubnet'

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


// resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
//   parent: hubVnet
//   name: vmSubnetName
// }

resource routeTable 'Microsoft.Network/routeTables@2021-02-01' = {
  name: 'vmSubnetRouteTable'
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
    ]
  }
}

resource subnetRouteTableAssociation1 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: vnet1
  name: vmSubnetName
  properties: {
    routeTable: {
      id: routeTable.id
    }
  }
}

resource subnetRouteTableAssociation2 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: vnet2
  name: vmSubnetName
  properties: {
    routeTable: {
      id: routeTable.id
    }
  }
}
