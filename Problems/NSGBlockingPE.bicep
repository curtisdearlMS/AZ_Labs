param resourceGroupName string = 'your-resource-group-name'
param nsgName string = 'vnet1-nsgVMSubnet'
param priority int = 1000
param direction string = 'Outbound'
param access string = 'Deny'
param protocol string = '*'
param sourcePortRange string = '*'
param destinationPortRange string = '*'
param sourceAddressPrefix string = '10.1.2.5' // IP address of VM 2
param destinationAddressPrefix string = '10.28.2.5' // IP address of Storage private endpoint

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name: nsgName
  scope: resourceGroup(resourceGroupName)
}

module nsgRule './Modules/nsgRule.bicep' = {
  name: 'nsgRuleModule'
  path: 'Modules/nsgRule.bicep'
  parent: nsg
  scope: resourceGroup(resourceGroupName)
  params: {
    nsgName: nsgName
    ruleName: 'blockPE${uniqueString(resourceGroup().id, nsgName, priority)[0:5]}'
    priority: priority
    direction: direction
    access: access
    protocol: protocol
    sourcePortRange: sourcePortRange
    destinationPortRange: destinationPortRange
    sourceAddressPrefix: sourceAddressPrefix
    destinationAddressPrefix: destinationAddressPrefix
  }
}
