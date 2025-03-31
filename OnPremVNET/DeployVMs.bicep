@description('Existing Virtual Network')
resource OPvnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: 'OnPremVNET'
}
// Deploy VMs into VNET1
param adminUsername string = 'bob'

@secure()
param adminPassword string = newGuid()

@description('Size of the VM')
param vmSize string = 'Standard_D2s_v6'

@description('True enables Accelerated Networking and False disables it. Not all VM sizes support Accel Net')
var accelNet = false

var vmCount = 2

@description('Network interfaces for VMs')
resource nicsvnet1 'Microsoft.Network/networkInterfaces@2022-09-01' = [for i in range(0, vmCount): {
  name: 'OnPremVNET-vm${i + 1}NIC'
  location: resourceGroup().location
  dependsOn: [
    OPvnet
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '192.168.3.${i + 4}'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'OnPremVNET', 'VirtualMachineSubnet')
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
  name: 'OnPremVNET-vm${i + 1}'
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
        name: 'OnPremVNET-vm${i + 1}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'OnPremVNET-vm${i + 1}'
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
          id: resourceId('Microsoft.Network/networkInterfaces', 'OnPremVNET-vm${i + 1}NIC')
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
