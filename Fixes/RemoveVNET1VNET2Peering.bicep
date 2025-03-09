// Define the existing VNets
resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'VNET1'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'VNET2'
}

// Define the existing peering resources
resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'VNET1toVNET2'
  parent: vnet1
  properties: {
    remoteVirtualNetwork: {
      id: vnet2.id
    }
    allowVirtualNetworkAccess: false
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'VNET2toVNET1'
  parent: vnet2
  properties: {
    remoteVirtualNetwork: {
      id: vnet1.id
    }
    allowVirtualNetworkAccess: false
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
