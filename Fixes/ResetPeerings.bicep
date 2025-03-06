// Reference existing VNETs
resource hubVnet 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: 'HubVNET'
}

resource vnet1 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: 'VNET1'
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-06-01' existing = {
  name: 'VNET2'
}

// Module to create peering between VNET1 and HubVNET
module vnet1Peering '../VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'vnet1PeeringDeployment'
  dependsOn: [
    hubVnet
    vnet1
  ]
  params: {
    hubVnetName: hubVnet.name
    vnet1Name: vnet1.name
  }
}

// Module to create peering between VNET2 and HubVNET
module vnet2Peering '../VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'vnet2PeeringDeployment'
  dependsOn: [
    hubVnet
    vnet2
  ]
  params: {
    hubVnetName: hubVnet.name
    vnet2Name: vnet2.name
  }
}
