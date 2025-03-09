# Training Labs: Network Misconfiguration Scenarios

This document will guide you through various Bicep templates that intentionally misconfigure network settings such as route tables, NSGs, and VNet Peerings. These scenarios are designed for learning purposes to understand the impact of network misconfigurations.

## Table of Contents
1. [Introduction](#introduction)
2. [Scenario 1: Misconfigured Route Table](#scenario-1-misconfigured-route-table)
3. [Scenario 2: Incorrect NSG Rules](#scenario-2-incorrect-nsg-rules)
4. [Scenario 3: Faulty VNet Peering](#scenario-3-faulty-vnet-peering)
5. [Reset to Default Configuration](#reset-to-default-configuration)

## Introduction
This document provides basic networking scenarios that can be demonstrated using Bicep templates. Each scenario will break network connectivity in different ways. At the end of the document, a reset to default template is provided to restore the configuration to a standard starting point.

> **Warning:** After deploying each problem template, use the reset template to return to the 'default' network configuration. The default configuration can be viewed in the provided draw.io diagram.

## Scenario 1: Misconfigured Route Table
Description: This scenario demonstrates the impact of a misconfigured route table.

This will deploy a route table to VNET 1 that will break traffic. 
Why can the VM's in VNET 1 VM Subnet still reach the hub VNET Storage Account Private Endpoint? What other changes would break that communication?

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2Fmisconfiguredroutetable.json)

## Scenario 2: Incorrect NSG Rules
Description: This scenario demonstrates the impact of incorrect NSG rules.

This will deploy an NSG rule into the VNET 1 VM subnet NSG.

This 1 rule will blocked VM2 in VNET 1 from communicating with the storage account Private IP address in the Hub VNET. Do connection tests from VM1 and VM2 to the Private Endpoint.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FNSGBlockingPE.json)

## Scenario 3: Faulty VNet Peering
Description: This scenario demonstrates the impact of faulty VNet peering.

This will deploy a VNET peering between VNET1 and VNET2. 

This will remove the routes in the route tables that are designed for transitive VNET routing via the VNET Gateway and/or the Azure Fireall. If the VNET Gateway or the Azure Fireall are not deployed AND the routes for transitive routing were not added the VMs in VNET 1 and VNET 2 will not be able to communicate each other with out directly peering the VNETs to each other. 

This should deploy the VNET 1 to VNET 2 peering and the VMs should be able to reach each other once VNET 1 is peered to VNET 2, however there is a problem with the VNET peering. 

Check the VNET peerings to find the problem, correct the misconfiguration and test. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FProblems%2FFaultyVNETPeering.json)

## Reset to Default Configuration
Description: This template resets the network configuration to a standard starting point.

This removes all NSG rules, restores routes for transitive routing on the VM subnet route tables, and disables the VNET1 - VNET2 peering. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FFullReset.json)
