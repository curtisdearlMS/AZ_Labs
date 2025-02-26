@description('Name of the storage account')
param storageAccountName string = uniqueString(resourceGroup().id, 'storageAccount')

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the resource group containing the virtual networks')
param vnetResourceGroupName string = resourceGroup().name

@description('Names of the virtual networks')
param hubVnetName string = 'hubvnet'
param vnet1Name string = 'vnet1'
param vnet2Name string = 'vnet2'

@description('Name of the private DNS zone')
param privateDnsZoneName string = 'privatelink.${environment().suffixes.storage}'

// Module to create the storage account
module storageAccountModule './Modules/storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

// Module to create the private endpoint
module privateEndpointModule './Modules/privateEndpoint.bicep' = {
  name: 'privateEndpointModule'
  params: {
    storageAccountName: storageAccountName
    vnetResourceGroupName: vnetResourceGroupName
    hubVnetName: hubVnetName
  }
}

// Module to create the private DNS zone
module privateDnsZoneModule './Modules/privateDnsZone.bicep' = {
  name: 'privateDnsZoneModule'
  params: {
    privateDnsZoneName: privateDnsZoneName
  }
}

// Module to create the virtual network links
module hubVnetLinkModule './Modules/virtualNetworkLink.bicep' = {
  name: 'hubVnetLinkModule'
  params: {
    privateDnsZoneName: privateDnsZoneName
    vnetResourceGroupName: vnetResourceGroupName
    vnetName: hubVnetName
  }
}

module vnet1LinkModule './Modules/virtualNetworkLink.bicep' = {
  name: 'vnet1LinkModule'
  params: {
    privateDnsZoneName: privateDnsZoneName
    vnetResourceGroupName: vnetResourceGroupName
    vnetName: vnet1Name
  }
}

module vnet2LinkModule './Modules/virtualNetworkLink.bicep' = {
  name: 'vnet2LinkModule'
  params: {
    privateDnsZoneName: privateDnsZoneName
    vnetResourceGroupName: vnetResourceGroupName
    vnetName: vnet2Name
  }
}
