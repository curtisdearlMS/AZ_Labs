var firewallPolicies_AzureFirewallAllowPolicy_name = 'AllowPolicy'

resource firewallPolicies_AllowPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' = {
  name: firewallPolicies_AzureFirewallAllowPolicy_name
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
  parent: firewallPolicies_AllowPolicy
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'AllowALL'
            ipProtocols: [
              'ANY'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '*'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '*'
            ]
          }
        ]
        name: 'AllowALL'
        priority: 500
      }
    ]
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: 'myAzureFirewall'
  location: resourceGroup().location
  properties:{  
    firewallPolicy: {
      id: firewallPolicies_AllowPolicy.id
    }
  }
}
