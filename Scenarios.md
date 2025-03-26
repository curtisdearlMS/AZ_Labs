# Training Labs: Network Misconfiguration Scenarios

This document will guide you through various Bicep templates that intentionally misconfigure network settings such as route tables, NSGs, and VNet Peerings. These scenarios are designed for learning purposes to understand the impact of network misconfigurations.

## Table of Contents

1. [Scenario 1: VM to VM, Between VNETs](#scenario-1-vm-to-vm-between-vnets)
2. [Scenario 2: Access to VMs is Broken](#scenario-2-access-to-vms-is-broken)
3. [Scenario 3: VPN connectivity](#scenario-3-vpn-connectivity)
4. [Scenario 4: Azure Firewall](#scenario-4-azure-firewall)
5. [Scenario 5: Private Endpoint](#scenario-5-private-endpoint)
6. [Scenario 6: Private Endpoint DNS](#scenario-6-private-endpoint-dns)

> **Warning:** After deploying each Scenario template, use the reset template to return to the 'default' network configuration. The default configuration can be viewed in the provided Visio diagram.

## Scenario 1: VM to VM, Between VNETs

### Deploy Incorrect NSG rules that prevent VNET to VNET traffic

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingvnet1VM2toVNET2.json)

### Fix the NSG rules to Allow VNET to VNET traffic

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetNSGs.json)


## Scenario 2: Access to VMs is Broken

### The public IP should allow access on Port 80. Deploy this to break inbound access.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB80Probe.json)

### Fix the LB configureation by deploying the following.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)


## Scenario 3: VPN connectivity

This requires a second VPN Gateway to be deployed to simulate an On Premises VPN device. This assumes you have deployed the VNET Gateway into the HubVNET. 

### Deploy the VNET Gateway if not deployed

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FHubVNETGateway%2FVNETGateway2.json)

### Deploy the Broken IPsec Connection to the On Prem VPN Device
This deploys the incorrectly configured VPN tunnel. Why can VNET1 and VNET2 not reach the on premise IP ranges. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FIncorrectIPSecConfig.json)

### Correct the IPsec configuration

This corrects the Site-to-Site configuration and permits communication across the IPsec tunnel.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FCorrectIPSecConfig.json)


## Scenario 4: Azure Firewall

This assumes that you have the Azure Firewall deployed.

### Deploy an Azure Firewall policy which Blocks VNET1 to VNET2

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FAzureFirewallBlocking.json)

### Deploy an Azure Firewall Policy which Allows VNET1 to VNET2

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FAzureFirewallAllowPolicy.json)

### Depoly VNET1 to VNET2 Peering

Why does VNET1 to VNET2 traffic no longer show up in the firewall logs when VNET1 and VNET2 are directly peered?

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FSpokeVNETPeering.json)

### Leave VNET1 to VNET2 Peering enabled, but force VNET1 to VNET2 traffic through the Azure Firewall

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetRouteTables2.json)


## Scenario 5: Private Endpoint

After deploying the problem, why cant VNET1 VMs reach the Private Endpoint in the HubVNET

### Deploy the following to block access to the PE

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingPE.json)

### Correct the Problem

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmai%2FFixes%2FResetNSGs.json)

## Scenario 6: Private Endpoint DNS

### Deploy the problem to break VNET1s DNS for the PE in the HubVNET

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)

### Correct the DNS entry to restore Access to the PE in the HubVNET

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetNSGs.json)
