param privateEndpointName string
param privateDnsZoneName string
param privateDnsZoneResourceGroup string
param privateEndpointResourceGroup string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' existing = {
  name: privateEndpointName
  scope: resourceGroup(privateEndpointResourceGroup)
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privateDnsZoneName
  scope: resourceGroup(privateDnsZoneResourceGroup)
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = {
  name: '${privateEndpointName}-dnsZoneGroup'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
