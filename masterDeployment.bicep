param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string

module hubVnet 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/HubVNET/HubVNET.bicep' = {
  name: 'hubVnetDeployment'
  params: {
    location: location
  }
}

module vnet1 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VNET1/VNET1.bicep' = {
  name: 'vnet1Deployment'
  params: {
    location: location
  }
}

module vnet1Peering 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VNET1/VNET1-HubVNETpeering.bicep' = {
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

module vnet2 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VNET2/VNET2.bicep' = {
  name: 'vnet2Deployment'
  params: {
    location: location
  }
}

module vnet2Peering 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VNET2/VNET2-HubVNETpeering.bicep' = {
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

module vnet1Vms 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VMs/VNET1_2VMs.bicep' = {
  name: 'vnet1VmsDeployment'
  dependsOn: [
    vnet1
  ]
  params: {
    vnetName: 'VNET1'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vnet2Vms 'https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/VMs/VNET2_2VMs.bicep' = {
  name: 'vnet2VmsDeployment'
  dependsOn: [
    vnet2
  ]
  params: {
    vnetName: 'VNET2'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
