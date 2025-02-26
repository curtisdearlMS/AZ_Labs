param vnet1NsgName string = 'VNET1-nsgVMSubnet'
param vnet2NsgName string = 'VNET2-nsgVMSubnet'

resource vnet1Nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name: vnet1NsgName
}

resource vnet2Nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name: vnet2NsgName
}

resource vnet1NsgRule1 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: 'CORPNET-SSH-RDP-1'
  parent: vnet1Nsg
  properties: {
    priority: 150
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'CorpNetSaw'
    destinationAddressPrefix: '*'
  }
}

resource vnet1NsgRule2 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: 'CORPNET-SSH-RDP-2'
  parent: vnet1Nsg
  properties: {
    priority: 160
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'CorpnetPublic'
    destinationAddressPrefix: '*'
  }
}

resource vnet2NsgRule1 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: 'CORPNET-SSH-RDP-1'
  parent: vnet2Nsg
  properties: {
    priority: 150
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'CorpNetSaw'
    destinationAddressPrefix: '*'
  }
}

resource vnet2NsgRule2 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: 'CORPNET-SSH-RDP-2'
  parent: vnet2Nsg
  properties: {
    priority: 160
    direction: 'Inbound'
    access: 'Allow'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: 'CorpnetPublic'
    destinationAddressPrefix: '*'
  }
}
