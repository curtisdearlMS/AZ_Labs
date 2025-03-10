var vnetName = 'HubVNET'
var firewallName = 'myAzureFirewall'
var publicIpFirewallName = 'fwPublicIP'

var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureFirewallSubnet')

resource publicIpFirewall 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpFirewallName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: firewallName
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'firewallIPConfig'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIpFirewall.id
          }
        }
      }
    ]
  }
}
