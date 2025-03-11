//param vmSize string = 'Standard_D2s_v6' 
//param adminUsername string = 'bob'
@secure()
param adminPassword string = newGuid()

// Module to deploy HubVNET
module hubVnet './HubVNET/HubVNET.bicep' = {
  name: 'Deploy Hub VNET'
  params: {
    vnetName: 'HubVNET'
  }
}

// Module to deploy VNET1
module vnet1 './VNET1/VNET1.bicep' = {
  name: 'Deploy VNET1'
  params: {
  }
}

// Module to create peering between VNET1 and HubVNET
module vnet1Peering './VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'Peer VNET 1 and Hub VNET'
  dependsOn: [
    hubVnet
    vnet1
  ]
  params: {
    hubVnetName: 'HubVNET'
    vnet1Name: 'VNET1'
  }
}

// Module to deploy VNET2
module vnet2 './VNET2/VNET2.bicep' = {
  name: 'Deploy VNET 2'
  params: {
  }
}

// Module to create peering between VNET2 and HubVNET
module vnet2Peering './VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'Peer VNET 2 and Hub VNET'
  dependsOn: [
    hubVnet
    vnet2
  ]
  params: {
    hubVnetName: 'HubVNET'
    vnet2Name: 'VNET2'
  }
}

// Module to deploy VMs in VNET1
module vnet1Vms './VMs/VNET1_2VMs.bicep' = {
  name: 'Deploy 2 VMs into VNET1'
  dependsOn: [
    vnet1
    vnet1Peering
  ]
  params: {
    //vnetName: 'VNET1'
    //vmSubnetName: 'VMSubnet'
    //adminUsername: adminUsername
    adminPassword: adminPassword
    //vmSize: vmSize
  }
}

// Module to deploy VMs in VNET2
module vnet2Vms './VMs/VNET2_2VMs.bicep' = {
  name: 'Deploy 2 VMs into VNET2'
  dependsOn: [
    vnet1Vms //wait for vnet1VMs to finish
    vnet2
    vnet2Peering
  ]
  params: {
    //vnetName: 'VNET2'
    //vmSubnetName: 'VMSubnet'
    //adminUsername: adminUsername
    adminPassword: adminPassword
    //vmSize: vmSize
  }
}

// Deploy the Storage Account, Private Endpoint, and Private DNS zone, Create A record for PE, Link to all 3 VNETs
module createSAandPE './HubVNET/CreateSAandPE.bicep' = {
  name: 'Deploy the Storage Account, Private Endpoint, and Private DNS zone, Create A record for PE, Link to all 3 VNETs'
  dependsOn: [
    vnet1
    vnet2
    hubVnet
  ]
}

// Module to deploy the VNET1 external load balancer
module vnet1LoadBalancer './VNET1/VNET1-ExternalStandardLB.bicep' = {
  name: 'Deploy the External Standard Load Balancer in VNET1'
  dependsOn: [
    vnet1
    vnet1Vms
  ]
}
