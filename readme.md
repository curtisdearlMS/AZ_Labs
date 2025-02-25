**Note:** Right-click the button below and select "Open link in new tab"

### Deploy HubVNET
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FHubVNET%2FHubVNET.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy VNET1
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy VNET1 to HubVNET Peering
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET1%2FVNET1-HubVNETpeering.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy VNET2
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET2%2FVNET2.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy VNET2 to HubVNET Peering
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVNET2%2FVNET2-HubVNETpeering.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Before Deploying the VMs
Run the following cloud shell for the region you are using, pick a x64 sku for a linux VM:
```sh
az vm list-skus --location REGION --output table
```

### Deploy VNET1 VMs
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVMs%2FVNET1_2VMs.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy VNET2 VMs
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FVMs%2FVNET2_2VMs.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>

### Deploy Storage Account, Private Endpoint, and Private DNS Zone
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FStorageAccount%2FCreateHubPrivateEndpoint.bicep"> <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" /> 
</a>

### Deploy All Resources
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftAzureAaron%2FNET_TrainingLabs%2Fmain%2FmasterDeployment.json">
  <img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure" />
</a>