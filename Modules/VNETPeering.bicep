param vnet1Id string
param vnet2Id string
param AVNA bool = false
param AFT bool = false    
param AGT bool = false
param URG bool = false

resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${vnet1Id}-to-${vnet2Id}'
  properties: {
    remoteVirtualNetwork: {
      id: vnet2Id
    }
    allowVirtualNetworkAccess: AVNA
    allowForwardedTraffic: AFT
    allowGatewayTransit: AGT
    useRemoteGateways: URG
  }
}
