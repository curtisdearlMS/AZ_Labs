resource nsgVMSubnetVNET1 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'VNET1-nsgVMSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource nsgVMSubnetVNET2 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'VNET2-nsgVMSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'VNET1-vm2NIC'
  location: resourceGroup().location
  properties: {
    networkSecurityGroup: {
      id: null
    }
  }
}
