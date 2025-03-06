// Reference the existing VNET1
resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet1'
  scope: resourceGroup()
}

// Reference the existing VNET2
resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet2'
  scope: resourceGroup()
}

resource rtVMSubnet1 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnet1.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.1'
        }
      }
      {
        name: 'Route1'
        properties: {
          addressPrefix: '0.0.0.0/1'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.2' 
        }
      }
      {
        name: 'Route2'
        properties: {
          addressPrefix: '128.0.0.0/1'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.2' 
        }
      }
      {
        name: 'Route10'
        properties: {
          addressPrefix: '10.0.0.0/8'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.3' 
        }
      }
      {
        name: 'Route192'
        properties: {
          addressPrefix: '192.168.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.4' 
        }
      }
      {
        name: 'Route10.2'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.5' 
        }
      }
      {
        name: 'Route10.3'
        properties: {
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '1.1.1.6' 
        }
      }
    ]
  }
}
