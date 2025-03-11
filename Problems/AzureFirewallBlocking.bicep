var firewallPolicies_AzureFirewallBlockingPolicy_name = 'BlockingPolicy'

resource firewallPolicies_BlockPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' = {
  name: firewallPolicies_AzureFirewallBlockingPolicy_name
  location: resourceGroup().location
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Off'
    threatIntelWhitelist: {
      fqdns: []
      ipAddresses: []
    }
  }
}

resource firewallPolicies_DefaultNetworkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  parent: firewallPolicies_BlockPolicy
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Deny'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'BlockVNET1toVNET2'
            ipProtocols: [
              'UDP'
              'TCP'
            ]
            sourceAddresses: [
              '10.1.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'BlockVNET2toVNET1'
            ipProtocols: [
              'UDP'
              'TCP'
            ]
            sourceAddresses: [
              '10.2.0.0/16'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
        name: 'BlockVNETtoVNET'
        priority: 10000
      }
    ]
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: 'myAzureFirewall'
  location: resourceGroup().location
  properties:{  
    firewallPolicy: {
      id: firewallPolicies_BlockPolicy.id
    }
  }
}


