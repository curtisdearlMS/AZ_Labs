param vmSize string = 'Standard_D2s_v6' 
param adminUsername string = 'bob'
@secure()
param adminPassword string
var storageAccountName = toLower(substring(uniqueString(resourceGroup().id, 'storageAccount'), 0, 13))
var privateEndpointName = '${storageAccountName}-hub-pe'
var resolvedPrivateEndpointName = empty(privateEndpointName) ? '${storageAccountName}-hub-pe' : privateEndpointName


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

// Module to create the storage account
module storageAccountModule './StorageAccount/StorageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
  }
}

// Module to create the private endpoint for the storage account
module privateEndpointModule './StorageAccount/StorageAccountPrivateEndpoint.bicep' = {
  name: 'privateEndpointModule'
  dependsOn: [
    hubVnet
    storageAccountModule
  ]
  params: {
    storageAccountName: storageAccountName
    location: resourceGroup().location
    vnetName: 'HubVNET'
    subnetName: 'PrivateEndpointSubnet'
    privateEndpointName: resolvedPrivateEndpointName
  }
}

// Module to create the private DNS zone for the private endpoint
module privateDnsZoneModule './StorageAccount/PrivateDNSZone.bicep' = {
  name: 'privateDnsZoneModule'
  dependsOn: [
    hubVnet
    vnet1
    vnet2
    privateEndpointModule
    storageAccountModule
  ]
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
  }
}

// Module to add the Private Endpoint Record to the Private DNS Zone
module privateDnsZoneRecordModule './StorageAccount/PrivateDNSZoneRecord.bicep' = {
  name: 'privateDnsZoneRecordModule'
  dependsOn: [
    privateDnsZoneModule
    privateEndpointModule
  ]
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    privateEndpointName: resolvedPrivateEndpointName
    privateDnsZoneResourceGroup: resourceGroup().name
    privateEndpointResourceGroup: resourceGroup().name
  }
}


// Module to link the private DNS zone to the HubVNET
module linkPrivateDnsZoneHub './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneHub'
  dependsOn: [
    hubVnet
    privateDnsZoneModule
  ]
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: 'HubVNET'
  }
}

// Module to link the private DNS zone to VNET1
module linkPrivateDnsZoneVnet1 './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneVnet1'
  dependsOn: [
    vnet1
    privateDnsZoneModule
    privateEndpointModule
  ]
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: 'VNET1'
  }
}

// Module to link the private DNS zone to VNET2
module linkPrivateDnsZoneVnet2 './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneVnet2'
  dependsOn: [
    vnet2
    privateDnsZoneModule
    privateEndpointModule
  ]
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: 'VNET2'
  }
}

// Deploy VNET Gateway and Azure Firewall only if you have time for the creation
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
