var nsgName = 'myNICNSG'

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'DenyAllInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

var VMsubnetID = resourceId('Microsoft.Network/virtualNetworks/subnets', 'VNET1', 'VMSubnet')

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'VNET1-vm2NIC'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: VMsubnetID
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}
