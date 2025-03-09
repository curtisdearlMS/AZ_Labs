var vnetName  = 'VNET2'
var vmSubnetName  = 'VMSubnet'
param adminUsername string = 'bob'
@secure()
param adminPassword string
param vmSize string = 'Standard_D2s_v6' 

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
  }
}
