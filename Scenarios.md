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
Description: This scenario demonstrates the impact of incorrect NSG rules.

Deploy Incorrect NSG rules that prevent VNET to VNET traffic
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingvnet1VM2toVNET2.json)

Fix the NSG rules to Allow VNET to VNET traffic
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetNSGs.json)


## Scenario 2: Access to VMs is Broken

The public IP should allow access on Port 80. Deploy this to break inbound access.
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB80Probe.json)

Fix the LB configureation by deploying the following.
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)


## Scenario 3: VPN connectivity

This requires a second VPN Gateway to be deployed to simulate an On Premises VPN device. This assumes you have deployed the VNET Gateway into the HubVNET. 

### Deploy the VNET Gateway
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FHubVNETGateway%2FVNETGateway.json)

### Deploy the Broken IPsec Connection to the On Prem VPN Device
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2F.json)

### Correct the IPsec configuration
This corrects the Site-to-Site configuration and permits communication across the IPsec tunnel.
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FAnswer%2FNSGBlockingPE.json)


## Scenario 4: Azure Firewall

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FAnswer%2FNSGBlockingPE.json)


## Scenario 5: Private Endpoint

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FAnswer%2FNSGBlockingPE.json)

## Scenario 6: Private Endpoint DNS

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FAnswer%2FNSGBlockingPE.json)
