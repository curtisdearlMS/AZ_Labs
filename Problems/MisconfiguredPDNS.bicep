@description('Name of the storage account')
var storageAccountName = uniqueString(resourceGroup().id, 'storageAccount')

@description('Name of the private DNS zone')
var privateDnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'

module PrivateDNSZoneArecord '../Modules/PrivateDNSZoneArecord.bicep' = {
  name: 'PrivateDNSZoneArecord'
  params: {
    PrivateDNSZone_Name: privateDnsZoneName
    ARecord_name: storageAccountName
    ipv4Address: '0.0.0.0'
    ttlInSeconds: 3600
  }
}

resource virtualNetworkLink1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', 'hubVNET')
    }
  }
}

resource virtualNetworkLink2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', 'VNET1')
    }
  }
}
