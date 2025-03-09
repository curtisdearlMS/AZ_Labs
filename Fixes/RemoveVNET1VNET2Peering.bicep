resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet1'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet2'
}

resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'VNET1toVNET2'
  parent: vnet1
  properties: {
    allowVirtualNetworkAccess: false
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    peeringState	: 'Disconnected'
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'VNET2toVNET1'
  parent: vnet2
  properties: {
    allowVirtualNetworkAccess: false
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    peeringState	: 'Disconnected'
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
