param hubVnetName string = 'hubvnet'
param peSubnetName string = 'PrivateEndpointSubnet'
param peSubnetAddressPrefix string = '10.28.2.0/24' // why is this hardcoded and not a referernce 

resource hubVnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: hubVnetName
}

resource peSubnetPolicy 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: hubVnet
  name: peSubnetName
  properties: {
    addressPrefix: peSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
  }
}
param firewallIp string = '10.28.15.4'
param vmSubnetName string = 'VMSubnet'

resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: hubVnet
  name: vmSubnetName
}

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

resource subnetRouteTableAssociation 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: hubVnet
  name: vmSubnetName
  properties: {
    routeTable: {
      id: routeTable.id
    }
  }
}
