param hubVnetName string = 'hubVNet'
param vnet1Name string = 'vnet1'
param vnet2Name string = 'vnet2'

resource vnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet1Name}/vnet1ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    allowGatewayTransit: true
  }
}

resource vnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet2Name}/vnet2ToHubPeering'
  properties: {
    remoteVirtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', hubVnetName)
    }
    allowGatewayTransit: true
  }
}
