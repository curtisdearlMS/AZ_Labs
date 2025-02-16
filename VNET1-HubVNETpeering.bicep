param hubVnetName string = 'Hub_VNET_172_12_0_0_16'
param vnet1Name string = 'VNET1'
param hubVnetResourceGroup string
param vnet1ResourceGroup string

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup(hubVnetResourceGroup)
}

resource vnet1 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnet1Name
  scope: resourceGroup(vnet1ResourceGroup)
}

resource hubToVnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${hubVnetName}/hubToVnet1Peering'
  location: hubVnet.location
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
  name: '${vnet1Name}/vnet1ToHubPeering'
  location: vnet1.location
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
