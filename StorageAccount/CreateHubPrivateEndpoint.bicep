param storageAccountName string = 'troubleshooting'
param hubVnetName string
param hubSubnetName string
param privateEndpointName string = '${storageAccountName}-hub-pe'

// Module to create the storage account
module storageAccountModule 'StorageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    storageAccountName: storageAccountName
  }
}

// Module to create the private endpoint for the storage account
module privateEndpointModule 'StorageAccountPrivateEndpoints.bicep' = {
  name: 'privateEndpointModule'
  params: {
    storageAccountName: storageAccountName
    vnetName: hubVnetName
    subnetName: hubSubnetName
    privateEndpointName: privateEndpointName
  }
}
// Module to create the private DNS zone for the private endpoint
module privateDnsZoneModule 'PrivateDNSZone.bicep' = {
  name: 'privateDnsZoneModule'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
  }
}
// Module to link the private DNS zone to the VNET
module linkPrivateDnsZoneModule 'LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneModule'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: hubVnetName
  }
}
