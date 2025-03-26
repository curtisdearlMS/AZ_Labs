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
          nextHopIpAddress: '10.28.15.4' // Azure Firewall private IP
        }
      }
      {
        name: 'vnet2Route'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualNetworkGateway' // does work if the VNET GW is deploy, simpler to default to the Azure Firewall
        }
      }
    ]
  }
}

resource rtVMSubnet2 'Microsoft.Network/routeTables@2023-09-01' = {
  name: '${vnet2.name}-rtVMSubnet'
  location: resourceGroup().location
  properties: {
    routes: [
      {
        name: 'defaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.28.15.4' // Azure Firewall private IP
        }
      }
      {
        name: 'vnet1Route'
        properties: {
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualNetworkGateway' // does work if the VNET GW is deploy, simpler to default to the Azure Firewall      
        }
      }
    ]
  }
}
