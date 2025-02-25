param vmSize string = 'Standard_D2s_v6' 
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
    hubVnetName: 'HubVNET'
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
    hubVnetName: 'HubVNET'
    vnet2Name: 'VNET2'
  }
}

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
    storageAccountName: 'troubleshooting'
    location: resourceGroup().location
  }
}

// Module to create the private endpoint for the storage account
module privateEndpointModule './StorageAccount/StorageAccountPrivateEndpoints.bicep' = {
  name: 'privateEndpointModule'
  params: {
    storageAccountName: 'troubleshooting'
    location: resourceGroup().location
    vnetName: 'HubVNET'
    subnetName: 'AzureFirewallSubnet'
    privateEndpointName: 'troubleshooting-hub-pe'
  }
}

// Module to link the private DNS zone to the HubVNET
module linkPrivateDnsZoneHub './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneHub'
  params: {
    privateDnsZoneName: 'privatelink.${environment().suffixes.storage}'
    vnetName: 'HubVNET'
  }
}

// Module to link the private DNS zone to VNET1
module linkPrivateDnsZoneVnet1 './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneVnet1'
  params: {
    privateDnsZoneName: 'privatelink.${environment().suffixes.storage}'
    vnetName: 'VNET1'
  }
}

// Module to link the private DNS zone to VNET2
module linkPrivateDnsZoneVnet2 './StorageAccount/LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneVnet2'
  params: {
    privateDnsZoneName: 'privatelink.${environment().suffixes.storage}'
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

resource publicIpVpnGw 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'vpnGwPublicIP'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2023-09-01' = {
  name: 'myVpnGateway'
  location: resourceGroup().location
  dependsOn: [
    azureFirewall
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        properties: {
          subnet: {
            id: '${hubVnet.outputs.vnetId}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: publicIpVpnGw.id
          }
        }
      }
    ]
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    sku: {
      name: 'vpngw1'
      tier: 'vpngw1'
    }
  }
}
