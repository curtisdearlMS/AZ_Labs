@description('Azure Datacenter that the resource is deployed to')
param location string

@description('Name of the Private Endpoint')
param privateEndpoint_Name string

param privateLinkServiceId string

@description('Subnet ID that the Private Endpoint will be deployed to')
param privateEndpoint_SubnetID string 

@description('Resource ID of the Virtual Networks to be linked to the Private DNS Zone')
param virtualNetwork_IDs array

@description('The ID of a group obtained from the remote resource that this private endpoint should connect to.')
param groupID string

@description('''Name of the Private DNS Zone
Example: privatelink.blob.${environment().suffixes.storage}''')
param privateDNSZone_Name string

param tagValues object = {}

@description('Reads the last portion of the Service ID to get the name of the resource')
var resource_Name = last(split(privateLinkServiceId, '/'))

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: privateEndpoint_Name
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoint_Name}_to_${resource_Name}'
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [
            groupID
          ]
        }
      }
    ]
    subnet: {
      id: privateEndpoint_SubnetID
    }
  }
  tags: tagValues
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZone_Name
  location: 'global'
  tags: tagValues
}

resource privateDNSZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-04-01' = {
  parent: privateEndpoint
  name: '${groupID}ZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'default'
        properties: {
           privateDnsZoneId: privateDNSZone.id
        }
      }
    ]
  }
}

resource virtualNetworkLink_File 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [ for virtualNetwork_ID in virtualNetwork_IDs: {
  parent: privateDNSZone
  name: '${privateEndpoint.name}_to_${last(split(virtualNetwork_ID, '/'))}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork_ID
    }
  }
  tags: tagValues
}
]

// Retrieve the network interface ID from the private endpoint
var privateEndpointNIC = privateEndpoint.properties.networkInterfaces[0].id

// Retrieve the private IP address from the network interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-05-01' existing = {
  id: privateEndpointNIC
}

var privateEndpointPIP = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress

// Output the private IP address
output privateEndpointPrivateIPAddress string = privateEndpointPIP
