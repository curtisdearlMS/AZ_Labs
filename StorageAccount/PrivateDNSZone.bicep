param privateDnsZoneName string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2023-05-01' = {
  name: privateDnsZoneName
}
