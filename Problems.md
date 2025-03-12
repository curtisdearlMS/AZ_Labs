# Training Labs: Network Misconfiguration Scenarios

This document will guide you through various Bicep templates that intentionally misconfigure network settings such as route tables, NSGs, and VNet Peerings. These scenarios are designed for learning purposes to understand the impact of network misconfigurations.

## Table of Contents

1. [Problem 1: Misconfigured Route Table](#problem-1-misconfigured-route-table)
2. [Problem 2: Incorrect NSG Rules](#problem-2-incorrect-nsg-rules)
3. [Problem 3: Faulty VNet Peering](#problem-3-faulty-vnet-peering)
4. [Problem 4: NSG Blocking VM2 in VNET 1 from accessing VNET2](#problem-4-nsg-blocking-vm2-in-vnet-1-from-accessing-vnet2)
5. [Problem 5: Azure External Standard Load Balancer Health Probes Down](#problem-5-azure-external-standard-load-balancer-health-probes-down)
6. [Problem 6: Azure Firewall Blocking Traffic](#problem-6-azure-firewall-blocking-traffic)
7. [Problem 7: NIC NSG Blocking Traffic](#problem-7-nic-nsg-blocking-traffic)
8. [Problem 8: Private DNS zone Misconfiguration](#problem-8-private-dns-zone-misconfiguration)
9. [Reset to Default Configuration](#reset-to-default-configuration)

> **Warning:** After deploying each problem template, use the reset template to return to the 'default' network configuration. The default configuration can be viewed in the provided draw.io diagram.

## Problem 1: Misconfigured Route Table
Description: This scenario demonstrates the impact of a misconfigured route table.

This will deploy a route table to VNET 1 that will break traffic. 
Why can the VM's in VNET 1 VM Subnet still reach the hub VNET Storage Account Private Endpoint? What other changes would break that communication?

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2Fmisconfiguredroutetable.json)

## Problem 2: Incorrect NSG Rules
Description: This scenario demonstrates the impact of incorrect NSG rules.

This will deploy an NSG rule into the VNET 1 VM subnet NSG.

This 1 rule will block the VM2 in VNET 1 from communicating with the storage account Private IP address in the Hub VNET. Do connection tests from VM1 and VM2 to the Private Endpoint.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingPE.json)

## Problem 3: Faulty VNet Peering
Description: This scenario demonstrates the impact of faulty VNet peering.

This will deploy a VNET peering between VNET1 and VNET2. 

This will remove the routes in the route tables that are designed for transitive VNET routing via the VNET Gateway and/or the Azure Fireall. If the VNET Gateway or the Azure Fireall are not deployed AND the routes for transitive routing were not added the VMs in VNET 1 and VNET 2 will not be able to communicate each other with out directly peering the VNETs to each other. 

This should deploy the VNET 1 to VNET 2 peering and the VMs should be able to reach each other once VNET 1 is peered to VNET 2, however there is a problem with the VNET peering. 

Check the VNET peerings to find the problem, correct the misconfiguration and test. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FFaultyVNETPeering.json)

## Problem 4: NSG Blocking VM2 in VNET 1 from accessing VNET2
Description: This scenario demonstrates the impact of NSG rules blocking an IP range.

This creates 2 NSG rules that block VNET 2 from VM2 in VNET 1.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingvnet1VM2toVNET2.json)

## Problem 5: Azure External Standard Load Balancer Health Probes Down

This Deploys an Azure External Load Balancer for the VMs in VNET1. 

Why are the health probes down?

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-ExternalStandardLB.json)

## Problem 6: Azure Firewall Blocking Traffic

This requires the Azure Firewall is deployed in the HubVNET. 

This will deploy an Azure Firewall Policy that will block transitive VNET traffic from VNET 1 to VNET 2 from going through the Firewall. How could a smart user bypass this rule?

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FAzureFirewallBlocking.json)

## Problem 7: NIC NSG Blocking Traffic

This deploys an NSG applied to the NIC of VM2 in VNET 1. This demonstrates the behavior of multiple NSGs, and reminds everyone to check for both Subnet and NIC NSGs.

This NSG will also block health probe from the Azure Load Balancer.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNICNSG.json)

## Problem 8: Private DNS zone Misconfiguration

This deploys an incorrect A record for the Storage Private Endpoint. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FMisconfiguredPDNS.json)

## Reset to Default Configuration
Description: This template resets the network configuration to a standard starting point.

This removes all NSG rules, restores routes for transitive routing on the VM subnet route tables, and disables the VNET1 - VNET2 peering. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FFullReset.json)
