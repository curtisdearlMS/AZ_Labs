@description('Name of the storage account')
param storageAccountName string = uniqueString(resourceGroup().id, 'storageAccount')

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the resource group containing the virtual networks')
param vnetResourceGroupName string = resourceGroup().name

@description('Names of the virtual networks')
param hubVnetName string = 'hubvnet'
param vnet1Name string = 'vnet1'
param vnet2Name string = 'vnet2'

@description('Name of the private DNS zone')
param privateDnsZoneName string = 'privatelink.${environment().suffixes.storage}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: '${storageAccountName}-pe'
  location: location
  properties: {
    subnet: {
      id: resourceId('${vnetResourceGroupName}', 'Microsoft.Network/virtualNetworks/subnets', '${hubVnetName}', 'default')
    }
    privateLinkServiceConnections: [
      {
        name: '${storageAccountName}-pe-connection'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource privateDnsZoneGroup 'Microsoft.Network/privateDnsZoneGroups@2021-01-01' = {
  name: '${storageAccountName}-pdz-group'
  location: location
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
  dependsOn: [
    privateEndpoint
  ]
}

resource hubVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  name: '${hubVnetName}-link'
  properties: {
    virtualNetwork: {
      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${hubVnetName}'
    }
    registrationEnabled: false
  }
}

resource vnet1Link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  name: '${vnet1Name}-link'
  properties: {
    virtualNetwork: {
      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${vnet1Name}'
    }
    registrationEnabled: false
  }
}

resource vnet2Link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  parent: privateDnsZone
  name: '${vnet2Name}-link'
  properties: {
    virtualNetwork: {
      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${vnet2Name}'
    }
    registrationEnabled: false
  }
}
