# Problems and Fixes

## VNET Peering Fix

If you need to enable Gateway transit for the peering from VNET1 to Hub and from VNET2 to Hub, you can deploy the fix using the button below:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FUpdateVNETPeerings4VNG.json">
    <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

## NSG Rules for Public IP access over CorpNet and CorpSAW Fix

If you want to directly access the VMs this will allow traffic inbound on port 22 from CorpNet

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FNSGsForPublicAccess.json">
    <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

## Enable Private Endpoint policies for Route Tables, create routes for the VMs

This will override the system created /32 route and send private endpoint traffic through the Azure Firewall
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FFixes%2FRoutePEtrafficThroughFirewall.json">
    <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>
