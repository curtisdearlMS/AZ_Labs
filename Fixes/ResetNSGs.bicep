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
