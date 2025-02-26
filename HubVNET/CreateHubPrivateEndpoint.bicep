param hubVnetName string ='hubVNET'
var storageAccountName = toLower(substring(uniqueString(resourceGroup().id, 'storageAccount'), 0, 13))
var privateEndpointName = '${storageAccountName}-hub-pe'
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
module privateEndpointModule 'StorageAccountPrivateEndpoint.bicep' = {
  name: 'privateEndpointModule'
  params: {
    storageAccountName: storageAccountName
    vnetName: hubVnetName
    privateEndpointName: resolvedPrivateEndpointName
    subnetName: 'PrivateEndpointSubnet'
  }
  dependsOn: [
    storageAccountModule
  ]
}
// Check if the private DNS zone already exists
resource existingPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
}

// Module to create the private DNS zone for the private endpoint if it does not already exist
module privateDnsZoneModule 'PrivateDNSZone.bicep' = if (empty(existingPrivateDnsZone)) {
  name: 'privateDnsZoneModule'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
  }
  dependsOn: [
    storageAccountModule
    privateEndpointModule
  ]
}

//Module to add Private Endpoint to the Private DNS Zone
module privateModule 'PrivateDNSZoneLink.bicep' = {
  name: 'privateDnsZoneLinkModule'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: hubVnetName
  }
  dependsOn: [
    storageAccountModule
    privateEndpointModule
    privateDnsZoneModule
  ]
}

// Module to link the private DNS zone to the VNET
module linkPrivateDnsZoneModule 'LinkPrivateDNSZone.bicep' = {
  name: 'linkPrivateDnsZoneModule'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    vnetName: hubVnetName
  }
  dependsOn: [
    storageAccountModule
    privateEndpointModule
    privateDnsZoneModule
  ]
}
