param ruleName string
param priority int
param direction string = 'Inbound'
param access string = 'Allow'
param protocol string = '*'
param sourcePortRange string = '*'
param destinationPortRange string = '*'
param sourceAddressPrefix string = '*'
param destinationAddressPrefix string = '*'

resource nsgRule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: ruleName
  properties: {
    nsgName: nsgName
    ruleName: ruleName
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
