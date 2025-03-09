// Define the existing VNets
resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'VNET1'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'VNET2'
}

// Define the existing peering resources
resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' existing = {
  name: 'VNET1toVNET2'
  parent: vnet1
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' existing = {
  name: 'VNET2toVNET1'
  parent: vnet2
}

// Delete the peering resources
resource deletevnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: vnet1Peering.name
  parent: vnet1
  properties: {} // Empty properties to indicate deletion
}

resource deletevnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: vnet2Peering.name
  parent: vnet2
  properties: {} // Empty properties to indicate deletion
}
