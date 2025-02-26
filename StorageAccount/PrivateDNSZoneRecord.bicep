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

module privateDnsZoneGroupModule 'privateDnsZoneGroupModule.bicep' = {
  name: '${privateEndpointName}-dnsZoneGroupModule'
  scope: resourceGroup(privateEndpointResourceGroup)
  params: {
    privateEndpointName: privateEndpoint.name
    privateDnsZoneName: privateDnsZoneName
    privateDnsZoneId: privateDnsZone.id
  }
}
