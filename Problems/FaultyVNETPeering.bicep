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
  name: 'VNET1toVNET2'
  parent: vnet1
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

resource vnet2TOvnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'VNET2ToVNET1'
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

resource rtVMSubnet1 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnet1.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: []
  }
}

resource rtVMSubnet2 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnet2.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: []
  }
}

