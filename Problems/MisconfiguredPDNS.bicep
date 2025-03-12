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

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [ for virtualNetwork in ['HubVNET','VNET1']: {
  name: '${privateDnsZoneName}/${storageAccountName}_to_${virtualNetwork}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', virtualNetwork)
    }
  }
}
]

resource virtualNetworkUNLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [ for virtualNetwork in ['VNET2']: {
  name: '${privateDnsZoneName}/${storageAccountName}_to_${virtualNetwork}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: null
    }
  }
}
]
