param hubVnetName string = 'hubVNet'
param vnet1Name string = 'vnet1'
param vnet2Name string = 'vnet2'

resource hubToVnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${hubVnetName}/hubToVnet1Peering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnet1Name)
    }
    allowGatewayTransit: true
  }
}

resource hubToVnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${hubVnetName}/hubToVnet2Peering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnet2Name)
    }
    allowGatewayTransit: true
  }
}

resource vnet1ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet1Name}/vnet1ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    useRemoteGateways: true
  }
}

resource vnet2ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet2Name}/vnet2ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    useRemoteGateways: true
  }
}
