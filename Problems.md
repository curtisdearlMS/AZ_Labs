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

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/Problems/misconfiguredRouteTable.json)

## Scenario 2: Incorrect NSG Rules
Description: This scenario demonstrates the impact of incorrect NSG rules.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/Problems/NSGBlockingPE.json">
    <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

## Scenario 3: Faulty VNet Peering
Description: This scenario demonstrates the impact of faulty VNet peering.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/MicrosoftAzureAaron/NET_TrainingLabs/main/Problems/FaultyVNETPeering.json">
    <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

## Reset to Default Configuration
Description: This template resets the network configuration to a standard starting point.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/Fixes/resetToDefault.json)