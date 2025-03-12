// Module to deploy HubVNET
module hubVnet './HubVNET/HubVNET.bicep' = {
  name: 'Deploy_HubVNET'
  params: {
  }
}

// Module to deploy VNET1
module vnet1 './VNET1/VNET1.bicep' = {
  name: 'Deploy_VNET1'
  params: {
  }
}

// Module to create peering between VNET1 and HubVNET
module vnet1Peering './VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'Peer_VNET1_and_HubVNET'
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
  name: 'Deploy_VNET2'
  params: {
  }
}

// Module to create peering between VNET2 and HubVNET
module vnet2Peering './VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'Peer_VNET2_and_HubVNET'
  dependsOn: [
    hubVnet
    vnet2
  ]
  params: {
    hubVnetName: 'HubVNET'
    vnet2Name: 'VNET2'
  }
}

// Deploy the Storage Account Private Endpoint, and Private DNS zone, Create A record for PE, Link to all 3 VNETs
module createSAandPE './HubVNET/CreateSAandPE.bicep' = {
  name: 'Deploy_the_Storage_Account_and_Private_Endpoint'
 dependsOn: [
    vnet1
    vnet2
    hubVnet
  ]
}

// Module to deploy the VNET1 external load balancer
module vnet1LoadBalancer './VNET1/VNET1-ExternalStandardLB.bicep' = {
  name: 'Deploy_the_Public_Load_Balancer_in_VNET1'
  dependsOn: [
    vnet1
    vnet1Vms
  ]
}


//deploy vms here
