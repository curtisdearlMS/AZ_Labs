var hubVnetName = 'hubVNet'
var vnet1Name = 'vnet1'
var vnet2Name = 'vnet2'

resource hubVnet 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: hubVnetName
}

resource vnetGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' existing = {
  name: 'myVpnGateway'
}

resource hubToVnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = if (vnetGateway.id != '') {
  parent: hubVnet
  name: 'hubToVnet1Peering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnet1Name)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
  }
}

resource hubToVnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = if (vnetGateway.id != '') {
  parent: hubVnet
  name: 'hubToVnet2Peering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnet2Name)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
  }
}

resource vnet1ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = if (vnetGateway.id != '') {
  name: '${vnet1Name}/vnet1ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  }
  dependsOn: [
    hubToVnet1Peering
  ]
}

resource vnet2ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = if (vnetGateway.id != '') {
  name: '${vnet2Name}/vnet2ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  }
  dependsOn: [
    hubToVnet2Peering
  ]
}
