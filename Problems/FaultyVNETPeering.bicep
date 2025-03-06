param resourceGroupName string

// Reference the existing VNET1
resource vnet1 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet1'
  scope: resourceGroup(resourceGroupName)
}

// Reference the existing VNET2
resource vnet2 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: 'vnet2'
  scope: resourceGroup(resourceGroupName)
}

// Create the peering from VNET1 to VNET2
module vnetPeeringModule1 '../Modules/VNETPeering.bicep' = {
  name: 'vnetPeeringDeployment1'
  params: {
    vnet1Id: vnet1.id
    vnet2Id: vnet2.id
    AVNA: true
    AFT: false
    AGT: false
    URG: false
  }
}

// Create the peering from VNET2 to VNET1
module vnetPeeringModule2 '../Modules/VNETPeering.bicep' = {
  name: 'vnetPeeringDeployment2'
  params: {
    vnet1Id: vnet2.id
    vnet2Id: vnet1.id
    AVNA: false
    AFT: false
    AGT: false
    URG: false
  }
}
