module resetPeerings 'ResetPeerings.bicep' = {
  name: 'resetPeerings'
  params: {
    // Add necessary parameters here
  }
}

module resetNSGs 'ResetNSGs.bicep' = {
  name: 'resetNSGs'
  params: {
    // Add necessary parameters here
  }
}

module resetRouteTables 'ResetRouteTables.bicep' = {
  name: 'resetRouteTables'
  params: {
    // Add necessary parameters here
  }
}

module resetPEDNS '../HubVNET/CreateSAandPE.bicep' = {
  name: 'resetPrivateEndpoint'
  params: {
    // Add necessary parameters here
  }
}

// Define the firewall resource
resource firewall 'Microsoft.Network/azureFirewalls@2021-02-01' existing = {
  name: 'myAzureFirewall'
}

// Define the firewallExists variable using the id property
var firewallExists = !empty(firewall.id)

module allowPolicy '../HubAzureFirewall/AzureFirewallAllowPolicy.bicep' = if (firewallExists) {
  name: 'allowPolicy'
}
