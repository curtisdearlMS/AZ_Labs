var vnetName = 'OnPremVNET'
var publicIpVpnGwName = 'OnPremvpnGwPublicIP'
var vpnGatewayName = 'OnPremVpnGateway'
var vpnGatewaySku = 'vpngw1'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/24'
        '192.168.3.0/24'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '192.168.0.0/24'
        }
      }
      {
        name: 'VirtualMachineSubnet'
        properties: {
          addressPrefix: '192.168.3.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnet.id

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
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'GatewaySubnet')            
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
var LNG1 = 'HubVNETNetworkGateway'
var connection1 = 'OnPremToHubConnection'

var hubVNETAddressPrefix = [
  '10.28.0.0/16'
  '10.1.0.0/16'
  '10.2.0.0/16'
]

@secure()
param sKey string = newGuid()

resource hubVpnGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2023-09-01' existing = {
  scope: resourceGroup(subscription().subscriptionId, resourceGroup().name)
  name: 'vpnGwPublicIP'
}

resource localNetworkGatewayA 'Microsoft.Network/localNetworkGateways@2023-09-01' = {
  name: LNG1
  location: resourceGroup().location
  properties: {
    gatewayIpAddress: hubVpnGatewayPublicIP.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: hubVNETAddressPrefix
    }
  }
}

resource connectionA 'Microsoft.Network/vpnConnections@2023-09-01' = {
  name: connection1
  location: resourceGroup().location
  properties: {
    connectionType: 'IPsec'
    sharedKey: sKey
    virtualNetworkGateway1: {
      id: resourceId('Microsoft.Network/virtualNetworkGateways', 'OnPremVpnGateway')
    }
    localNetworkGateway2: {
      id: localNetworkGatewayA.id
    }
    enableBgp: false
  }
}

var LNG2 = 'OnPremVNETNetworkGateway'
var connection2 = 'HubToOnPremConnection'
var onPremVNETAddressPrefix = [
  '192.168.0.0/24'
  '192.168.3.0/24'
]

resource localNetworkGatewayB 'Microsoft.Network/localNetworkGateways@2023-09-01' = {
  name: LNG2
  location: resourceGroup().location
  properties: {
    gatewayIpAddress: publicIpVpnGw.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: onPremVNETAddressPrefix
    }
  }
}

resource connectionB 'Microsoft.Network/vpnConnections@2023-09-01' = {
  name: connection2
  location: resourceGroup().location
  properties: {
    connectionType: 'IPsec'
    sharedKey: sKey
    virtualNetworkGateway1: {
      id: resourceId('Microsoft.Network/virtualNetworkGateways', 'myVpnGateway')
    }
    localNetworkGateway2: {
      id: localNetworkGatewayB.id
    }
    enableBgp: false
  }
}
