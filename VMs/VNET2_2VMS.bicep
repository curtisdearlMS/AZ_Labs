var vnetName  = 'VNET2'
var vmSubnetName  = 'VMSubnet'
var adminUsername = 'bob'
@secure()
param adminPassword string
param vmSize string 

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: vmSubnetName
  parent: vnet
}

module vm1 '../Modules/linuxnettestvm.bicep' = {
  name: 'vm1Deployment'
  params: {
    location: resourceGroup().location
    vm_Name: '${vnetName}-vm1'
    vmSize: vmSize
    vm_AdminUserName: adminUsername
    vm_AdminPassword: adminPassword
    nic_Name: '${vnetName}-vm1NIC'
    accelNet: false
    subnetID: vmSubnet.id
    StaticIP: '10.2.2.4'
  }
}

module vm2 '../Modules/linuxnettestvm.bicep' = {
  name: 'vm2Deployment'
  params: {
    location: resourceGroup().location
    vm_Name: '${vnetName}-vm2'
    vmSize: vmSize
    vm_AdminUserName: adminUsername
    vm_AdminPassword: adminPassword
    nic_Name: '${vnetName}-vm2NIC'
    accelNet: false
    subnetID: vmSubnet.id
    StaticIP: '10.2.2.5'
  }
}
