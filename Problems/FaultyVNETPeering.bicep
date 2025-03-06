// Reference the existing VNET1
resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet1'
  scope: resourceGroup()
}

// Reference the existing VNET2
resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet2'
  scope: resourceGroup()
}

resource vnet1TOvnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'vnet1ToHubPeering'
  parent: vnet1
  properties: {
    remoteVirtualNetwork: {
      id: vnet1.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnet2TOvnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'vnet2ToHubPeering'
  parent: vnet2
  properties: {
    remoteVirtualNetwork: {
      id: vnet2.id
    }
    allowVirtualNetworkAccess: false
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

