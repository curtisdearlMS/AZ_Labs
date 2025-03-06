param ruleName string
param priority int
@allowed([
  'Inbound'
  'Outbound'
])
param direction string = 'Inbound'
@allowed([
  'Allow'
  'Deny'
])
param access string = 'Allow'
@allowed([
  'Tcp'
  'Udp'
  '*'
])
param protocol string = '*'

@allowed([
  '*'
  '80'
  '443'
])
param sourcePortRange string = '*'

@allowed([
  '*'
  '80'
  '443'
])
param destinationPortRange string = '*'

@allowed([
  '*'
  '10.0.0.0/8'
  '192.168.0.0/16'
])
param sourceAddressPrefix string = '*'

@allowed([
  '*'
  '10.0.0.0/8'
  '192.168.0.0/16'
])
param destinationAddressPrefix string = '*'

resource nsgRule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name: ruleName
  properties: {
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
