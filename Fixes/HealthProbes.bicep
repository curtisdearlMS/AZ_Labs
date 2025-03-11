// Description: This Bicep template modifies the health probe to use port 22.
var publicLoadBalancer_Name  = 'VNET1_Ext_VM_LB'

resource loadBalancer 'Microsoft.Network/loadBalancers@2024-01-01' = {
  name: publicLoadBalancer_Name
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    probes: [
      {
        name: 'port80healthprobe'
        properties: {
          protocol: 'Tcp'
          port: 22
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
        }
      }
    ]
  }
}
