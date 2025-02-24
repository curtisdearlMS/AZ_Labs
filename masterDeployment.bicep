param vmSize string = 'Standard_B2ms' 
param adminUsername string = 'bob'
@secure()
param adminPassword string

module hubVnet './HubVNET/HubVNET.bicep' = {
  name: 'hubVnetDeployment'
  params: {
    vnetName: 'HubVNET'
  }
}

module vnet1 './VNET1/VNET1.bicep' = {
  name: 'vnet1Deployment'
  params: {
  }
}

module vnet1Peering './VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'vnet1PeeringDeployment'
  dependsOn: [
    hubVnet
    vnet1
  ]
  params: {
    hubVnetName: 'Hub_VNET_172_12_0_0_16'
    vnet1Name: 'VNET1'
  }
}

module vnet2 './VNET2/VNET2.bicep' = {
  name: 'vnet2Deployment'
  params: {
  }
}

module vnet2Peering './VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'vnet2PeeringDeployment'
  dependsOn: [
    hubVnet
    vnet2
  ]
  params: {
    hubVnetName: 'Hub_VNET_172_12_0_0_16'
    vnet2Name: 'VNET2'
  }
}

module vnet1Vms './VMs/VNET1_2VMs.bicep' = {
  name: 'vnet1VmsDeployment'
  dependsOn: [
    vnet1
  ]
  params: {
    vnetName: 'VNET1'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
  }
}

module vnet2Vms './VMs/VNET2_2VMs.bicep' = {
  name: 'vnet2VmsDeployment'
  dependsOn: [
    vnet2
  ]
  params: {
    vnetName: 'VNET2'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
  }
}
