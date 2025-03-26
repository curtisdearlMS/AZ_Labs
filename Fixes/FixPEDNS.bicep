@description('Name of the storage account')
var storageAccountName = uniqueString(resourceGroup().id, 'storageAccount')

@description('Name of the private DNS zone')
var privateDnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'

module PrivateDNSZoneArecord '../Modules/PrivateDNSZoneARecord.bicep' = {
  name: 'PrivateDNSZoneArecord'
  params: {
    PrivateDNSZone_Name: privateDnsZoneName
    ARecord_name: storageAccountName
    ipv4Address: '10.25.2.4'
    ttlInSeconds: 3600
  }
}
