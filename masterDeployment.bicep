param vmSize string = 'Standard_D2s_v6' 
param adminUsername string = 'bob'
//@secure()
param adminPassword string = 'moonCAKE!'
// var storageAccountName = toLower(substring(uniqueString(resourceGroup().id, 'storageAccount'), 0, 13))
// var privateEndpointName = '${storageAccountName}-hub-pe'

// Module to deploy HubVNET
module hubVnet './HubVNET/HubVNET.bicep' = {
  name: 'hubVnetDeployment'
  params: {
    vnetName: 'HubVNET'
  }
}

// Module to deploy VNET1
module vnet1 './VNET1/VNET1.bicep' = {
  name: 'vnet1Deployment'
  params: {
  }
}

// Module to create peering between VNET1 and HubVNET
module vnet1Peering './VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'vnet1PeeringDeployment'
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
  name: 'vnet2Deployment'
  params: {
  }
}

// Module to create peering between VNET2 and HubVNET
module vnet2Peering './VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'vnet2PeeringDeployment'
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
  name: 'vnet1VmsDeployment'
  dependsOn: [
    vnet1
    vnet1Peering
  ]
  params: {
    vnetName: 'VNET1'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
  }
}

// Module to deploy VMs in VNET2
module vnet2Vms './VMs/VNET2_2VMs.bicep' = {
  name: 'vnet2VmsDeployment'
  dependsOn: [
    vnet1Vms //wait for vnet1VMs to finish
    vnet2
    vnet2Peering
  ]
  params: {
    vnetName: 'VNET2'
    vmSubnetName: 'VMSubnet'
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
  }
}

// Deploy the Storage Account, Private Endpoint, and Private DNS zone, Create A record for PE, Link to all 3 VNETs
module createSAandPE './HubVNET/CreateSAandPE.bicep' = {
  name: 'createSAandPEDeployment'
  dependsOn: [
    vnet1
    vnet2
    hubVnet
  ]
}

// Deploy Azure Firewall Public IP
resource publicIpFirewall 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'fwPublicIP'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
// Deploy the Azure firewall
resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: 'myAzureFirewall'
  location: resourceGroup().location
  dependsOn: [
    vnet1Vms
    vnet2Vms
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'firewallIPConfig'
        properties: {
          subnet: {
            id: '${hubVnet.outputs.vnetId}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: publicIpFirewall.id
          }
        }
      }
    ]
  }
}
