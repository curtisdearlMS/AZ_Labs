resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet1'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet2'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
  }
}

resource vnetPeering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  parent: vnet1
  name: 'vnet1-to-vnet2'
  properties: {
    remoteVirtualNetwork: {
      id: vnet2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource vnetPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  parent: vnet2
  name: 'vnet2-to-vnet1'
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
