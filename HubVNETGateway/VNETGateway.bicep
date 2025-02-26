param publicIpVpnGwName string = 'vpnGwPublicIP'
param vpnGatewayName string = 'myVpnGateway'
param vpnGatewaySku string = 'vpngw1'
param hubVnetId string

resource publicIpVpnGw 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpVpnGwName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: vpnGatewayName
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          subnet: {
            id: '${hubVnetId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: publicIpVpnGw.id
          }
        }
      }
    ]
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    sku: {
      name: vpnGatewaySku
      tier: vpnGatewaySku
    }
  }
}
