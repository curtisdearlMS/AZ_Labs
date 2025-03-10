resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-02-01' = {
  name: 'myFirewallPolicy'
  location: resourceGroup().location
  properties: {
    threatIntelMode: 'Alert'
  }
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-02-01' = {
  name: 'myRuleCollectionGroup'
  parent: firewallPolicy
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: 'blockVnet1ToVnet2'
        priority: 100
        ruleCollectionType: 'NetworkRuleCollection'
        action: {
          type: 'Deny'
        }
        rules: [
          {
            name: 'blockVnet1ToVnet2Rule'
            ruleType: 'NetworkRule'
            sourceAddresses: [
              '10.1.0.0/16' // VNET 1 address range
            ]
            destinationAddresses: [
              '10.2.0.0/16' // VNET 2 address range
            ]
            destinationPorts: [
              '*'
            ]
            protocols: [
              'Any'
            ]
          }
        ]
      }
    ]
  }
}

resource hubVnetFirewall 'Microsoft.Network/azureFirewalls@2020-11-01' existing = {
  name: 'hubVnetFirewall'
  scope: resourceGroup()
}

resource firewallPolicyAssociation 'Microsoft.Network/azureFirewalls/providers/firewallPolicies@2021-02-01' = {
  name: 'default'
  parent: hubVnetFirewall/providers/Microsoft.Network/firewallPolicies
  properties: {
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
}
