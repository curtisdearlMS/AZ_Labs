param hubVnetName string = 'Hub_VNET_172_12_0_0_16'
param vnet2Name string = 'VNET2'

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup()
}

resource vnet2 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnet2Name
  scope: resourceGroup()
}

resource hubToVnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'hubToVnet2Peering'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: vnet2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnet2ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'vnet2ToHubPeering'
  parent: vnet2
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
