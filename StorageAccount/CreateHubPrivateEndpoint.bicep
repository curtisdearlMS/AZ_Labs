var storageAccountName = uniqueString(resourceGroup().id, 'storageAccount')
param hubVnetName string
param privateEndpointName string
var resolvedPrivateEndpointName = empty(privateEndpointName) ? '${storageAccountName}-hub-pe' : privateEndpointName

// Module to create the storage account
module storageAccountModule 'StorageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
  }
}

// Module to create the private endpoint for the storage account
module privateEndpointModule 'StorageAccountPrivateEndpoints.bicep' = {
  name: 'privateEndpointModule'
  params: {
    storageAccountName: storageAccountName
    vnetName: hubVnetName
    privateEndpointName: resolvedPrivateEndpointName
    subnetName: 'default'
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
