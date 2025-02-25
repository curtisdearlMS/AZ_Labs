param hubVnetName string = 'Hub_VNET'
param vnet1Name string = 'VNET1'

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup()
}

resource vnet1 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnet1Name
  scope: resourceGroup()
}

resource hubToVnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'hubToVnet1Peering'
  parent: hubVnet
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

resource vnet1ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'vnet1ToHubPeering'
  parent: vnet1
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
