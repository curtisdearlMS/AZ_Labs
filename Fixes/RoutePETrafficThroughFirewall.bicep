param hubVnetName string = 'hubvnet'
param peSubnetName string = 'PrivateEndpointSubnet'

resource hubVnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: hubVnetName
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: hubVnet
  name: peSubnetName
}

resource peSubnetPolicy 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  parent: hubVnet
  name: peSubnetName
  properties: {
    addressPrefix: peSubnet.properties.addressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
  }
}
