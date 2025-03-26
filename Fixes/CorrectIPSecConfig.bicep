
var LNG2 = 'OnPremVNETNetworkGateway'

var onPremVNETAddressPrefix = [
  '192.168.0.0/24'
  '192.168.3.0/24'
]

resource OnPremVpnGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2023-09-01' existing = {
  scope: resourceGroup(subscription().subscriptionId, resourceGroup().name)
  name: 'OnPremvpnGwPublicIP'
}

resource localNetworkGatewayB 'Microsoft.Network/localNetworkGateways@2023-09-01' = {
  name: LNG2
  location: resourceGroup().location
  properties: {
    gatewayIpAddress: OnPremVpnGatewayPublicIP.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: onPremVNETAddressPrefix
    }
  }
}
