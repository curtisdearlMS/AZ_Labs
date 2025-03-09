var vnetName = 'VNET1'
var priority = 1000
var direction1 = 'Outbound'
var direction2 = 'Inbound'
var access = 'Deny'
var protocol = '*'
var sourcePortRange = '*'
var destinationPortRange = '*'
var sourceAddressPrefix = '10.1.2.5' // IP address of VM 2
var destinationAddressPrefix = '10.2.0.0/16' // IP address of Storage private endpoint

// Create a network security group (NSG) for the VM subnet, 
//this will block VM2 from accessing vnet2
resource nsgVMSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgVMSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'blockVNet1VM2toVNET2'
        properties: {
          priority: priority
          direction: direction1
          access: access
          protocol: protocol
          sourcePortRange: sourcePortRange
          destinationPortRange: destinationPortRange
          sourceAddressPrefix: sourceAddressPrefix
          destinationAddressPrefix: destinationAddressPrefix
        }
      }
      {
        name: 'blockVNEt2toVNet1VM2'
        properties: {
          priority: priority
          direction: direction2
          access: access
          protocol: protocol
          sourcePortRange: sourcePortRange
          destinationPortRange: destinationPortRange
          sourceAddressPrefix: destinationAddressPrefix 
          destinationAddressPrefix: sourceAddressPrefix
        }
      }
    ]
  }
}
