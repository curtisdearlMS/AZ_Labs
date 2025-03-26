# Fixes

## Enable Gateway Transit for VNET to Hub Peering Fix

If you need to enable Gateway transit for the peering from VNET1 to Hub and from VNET2 to Hub, you can deploy the fix using the button below.

This requires that the VPN GW has been deployed. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FUpdateVNETPeerings4VNG.json)

## NSG Rules for Public IP access over CorpNet and CorpSAW Fix

If you want to directly access the VMs via the LB Public IP, this will allow traffic inbound on port 22 from CorpNet and CorpVPN. However automation will remove these rules. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FNSGsForPublicAccess.json)

## Enable Private Endpoint policies for Route Tables, create routes for the VMs

This will override the system created /32 route and send private endpoint traffic through the Azure Firewall

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FRoutePETrafficThroughFirewall.json)

## Fix the Azure Load Balancer Health Probes

This will change the VNET1 VM load balancer to probe on port 22. (now default)

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FHealthProbes.json)

## Depoly VNET1 to VNET2 Peering correctly

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FSpokeVNETPeering.json)

## Use Azure System Default Route for VNET1 to VNET2 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetRouteTables2.json)

## Override VNET Peering Routes for VNET1 to VNET2 to use AZ FW

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetRouteTables.json)

## Override VNET Peering Routes for VNET1 to VNET2 to use VNET Gateway

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FResetRouteTables3.json)

## Reset All to Default Configuration
Description: This template resets the network configuration to a standard starting point.

This removes all NSG rules, restores routes for transitive routing on the VM subnet route tables, and disables the VNET1 - VNET2 peering. 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FFullReset.json)
