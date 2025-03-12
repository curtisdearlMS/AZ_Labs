var vnetName = 'VNET1'
var vmSubnetName = 'VMSubnet'
var adminUsername = 'bob'

@secure()
param adminPassword string = newGuid()

@description('Size of the VM')
param vmSize string = 'Standard_D2as_v4'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: vmSubnetName
  parent: vnet
}

// module vm1 '../Modules/linuxnettestvm.bicep' = {
//   name: 'vm1Deployment'
//   params: {
//     location: resourceGroup().location
//     vm_Name: '${vnetName}-vm1'
//     vmSize: vmSize
//     vm_AdminUserName: adminUsername
//     vm_AdminPassword: adminPassword
//     nic_Name: '${vnetName}-vm1NIC'
//     accelNet: false
//     subnetID: vmSubnet.id
//     StaticIP: '10.1.2.4'
//   }
// }

// module vm2 '../Modules/linuxnettestvm.bicep' = {
//   name: 'vm2Deployment'
//   params: {
//     location: resourceGroup().location
//     vm_Name: '${vnetName}-vm2'
//     vmSize: vmSize
//     vm_AdminUserName: adminUsername
//     vm_AdminPassword: adminPassword
//     nic_Name: '${vnetName}-vm2NIC'
//     accelNet: false
//     subnetID: vmSubnet.id
//     StaticIP: '10.1.2.5'
//   }
// }

@description('Name of the Virtual Machine')
var vm_Name = '${vnetName}-vm1'

@description('Name of the Virtual Machines Network Interface')
var nic_Name = '${vnetName}-vm1NIC'

@description('True enables Accelerated Networking and False disabled it.  Not all VM sizes support Accel Net')
var accelNet = false

resource nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: nic_Name
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          //privateIPAllocationMethod: 'Dynamic'
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.1.2.4'
          subnet: {
            id: vmSubnet.id
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
}

resource linuxVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vm_Name
  location: resourceGroup().location
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
        name: '${vm_Name}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vm_Name
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
          id: nic.id
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
}
