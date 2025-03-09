param vnetName string = 'VNET1'
param priority int = 1000
param direction1 string = 'Outbound'
param direction2 string = 'Inbound'
param access string = 'Deny'
param protocol string = '*'
param sourcePortRange string = '*'
param destinationPortRange string = '*'
param sourceAddressPrefix string = '10.1.2.5' // IP address of VM 2
param destinationAddressPrefix string = '10.2.0.0/16' // IP address of Storage private endpoint

// Create a network security group (NSG) for the VM subnet, 
//this will block VM2 from accessing the hub vnet PE for the storage account
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
        name: 'VNEt2toVNet1VM2'
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
