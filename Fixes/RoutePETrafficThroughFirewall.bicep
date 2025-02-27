param hubVnetName string = 'hubvnet'
param peSubnetName string = 'PrivateEndpointSubnet'
param peSubnetAddressPrefix string = '10.28.2.0/24'

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
    addressPrefix: peSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
  }
}
