// Module to deploy HubVNET
module hubVnet './HubVNET/HubVNET.bicep' = {
  name: 'Deploy_HubVNET'
  params: {
  }
}

// Module to deploy VNET1
module vnet1 './VNET1/VNET1.bicep' = {
  name: 'Deploy_VNET1'
  params: {
  }
}

// Module to create peering between VNET1 and HubVNET
module vnet1Peering './VNET1/VNET1-HubVNETpeering.bicep' = {
  name: 'Peer_VNET1_and_HubVNET'
  dependsOn: [
    hubVnet
    vnet1
  ]
  params: {
    hubVnetName: 'HubVNET'
    vnet1Name: 'VNET1'
  }
}

// Module to deploy VNET2
module vnet2 './VNET2/VNET2.bicep' = {
  name: 'Deploy_VNET2'
  params: {
  }
}

// Module to create peering between VNET2 and HubVNET
module vnet2Peering './VNET2/VNET2-HubVNETpeering.bicep' = {
  name: 'Peer_VNET2_and_HubVNET'
  dependsOn: [
    hubVnet
    vnet2
  ]
  params: {
    hubVnetName: 'HubVNET'
    vnet2Name: 'VNET2'
  }
}

// Deploy the Storage Account Private Endpoint, and Private DNS zone, Create A record for PE, Link to all 3 VNETs
module createSAandPE './HubVNET/CreateSAandPE.bicep' = {
  name: 'Deploy_the_Storage_Account_and_Private_Endpoint'
 dependsOn: [
    vnet1
    vnet2
    hubVnet
  ]
}

// Module to deploy the VNET1 external load balancer
module vnet1LoadBalancer './VNET1/VNET1-ExternalStandardLB.bicep' = {
  name: 'Deploy_the_Public_Load_Balancer_in_VNET1'
  dependsOn: [
    vnet1
    linuxVMsvnet1
  ]
}

//deploy vms here

// Deploy VMs into VNET1
param adminUsername string = 'bob'

@secure()
param adminPassword string = newGuid()

@description('Size of the VM')
param vmSize string = 'Standard_D2as_v4'

@description('True enables Accelerated Networking and False disables it. Not all VM sizes support Accel Net')
var accelNet = false

var vmCount = 2

@description('Network interfaces for VMs')
resource nicsvnet1 'Microsoft.Network/networkInterfaces@2022-09-01' = [for i in range(0, vmCount): {
  name: 'VNET1-vm${i + 1}NIC'
  location: resourceGroup().location
  dependsOn: [
    vnet1
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.1.2.${i + 4}'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'VNET1', 'VMSubnet')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: accelNet
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}]

resource linuxVMsvnet1 'Microsoft.Compute/virtualMachines@2023-03-01' = [for i in range(0, vmCount): {
  name: 'VNET1-vm${i + 1}'
  location: resourceGroup().location
  dependsOn: [
    nicsvnet1
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: 'VNET1-vm${i + 1}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'VNET1-vm${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'VNET1-vm${i + 1}NIC')
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}]

@description('Network interfaces for VMs')
resource nicsvnet2 'Microsoft.Network/networkInterfaces@2022-09-01' = [for i in range(0, vmCount): {
  name: 'VNET2-vm${i + 1}NIC'
  location: resourceGroup().location
  dependsOn: [
    vnet2
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.2.2.${i + 4}'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'VNET2', 'VMSubnet')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: accelNet
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}]

resource linuxVMsvnet2 'Microsoft.Compute/virtualMachines@2023-03-01' = [for i in range(0, vmCount): {
  name: 'VNET2-vm${i + 1}'
  location: resourceGroup().location
  dependsOn: [
    nicsvnet2
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: 'VNET2-vm${i + 1}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'VNET2-vm${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'VNET2-vm${i + 1}NIC')
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}]
