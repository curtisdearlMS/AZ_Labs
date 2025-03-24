var vnetName = 'VNET1'
var priority = 1000
var direction = 'Outbound'
var access = 'Deny'
var protocol = '*'
var sourcePortRange = '*'
var destinationPortRange = '*'
var sourceAddressPrefix = '10.1.2.5' // IP address of VM 2
var destinationAddressPrefix = '10.28.2.4' // IP address of Storage private endpoint

// Create a network security group (NSG) for the VM subnet, 
//this will block VM2 from accessing the hub vnet PE for the storage account
resource nsgVMSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vnetName}-nsgVMSubnet'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'blockPE'
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
    ]
  }
}
