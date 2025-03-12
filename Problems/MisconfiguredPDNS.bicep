@description('Name of the storage account')
param storageAccountName string = uniqueString(resourceGroup().id, 'storageAccount')

@description('Name of the private DNS zone')
param privateDnsZoneName string = 'privatelink.blob.${environment().suffixes.storage}'

module PrivateDNSZoneArecord '../Modules/PrivateDNSZoneArecord.bicep' = {
  name: 'PrivateDNSZoneArecord'
  params: {
    PrivateDNSZone_Name: privateDnsZoneName
    ARecord_name: storageAccountName
    ipv4Address: '256.256.256.256'
    ttlInSeconds: 3600
  }
}
