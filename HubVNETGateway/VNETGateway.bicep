var publicIpVpnGwName = 'vpnGwPublicIP'
var vpnGatewayName = 'myVpnGateway'
var vpnGatewaySku = 'vpngw1'
var hubVnetName = 'HubVNET'

//var hubVnetId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Network/virtualNetworks/${hubVnetName}'

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
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubVnetName, 'GatewaySubnet')            
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
