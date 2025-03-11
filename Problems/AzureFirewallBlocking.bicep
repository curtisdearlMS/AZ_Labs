var firewallPolicies_AzureFirewallBlockingPolicy_name = 'BlockingPolicy'

resource firewallPolicies_AzureFirewallBlockingPolicy_name_resource 'Microsoft.Network/firewallPolicies@2024-05-01' = {
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

resource firewallPolicies_AzureFirewallBlockingPolicy_name_DefaultNetworkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  parent: firewallPolicies_AzureFirewallBlockingPolicy_name_resource
  name: 'DefaultNetworkRuleCollectionGroup'
  location: resourceGroup().location
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
resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' existing = {
  name: 'myAzureFirewall'
  scope: resourceGroup()
}

resource firewallPolicyAssociation 'Microsoft.Network/azureFirewalls/firewallPolicies@2024-05-01' = {
  parent: azureFirewall
  name: 'firewallPolicyAssociation'
  properties: {
    firewallPolicy: {
      id: firewallPolicies_AzureFirewallBlockingPolicy_name_resource.id
    }
  }
}
