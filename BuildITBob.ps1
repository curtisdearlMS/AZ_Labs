# Define the directory containing the Bicep files
$bicepDirectory = "C:\Users\aarosanders\Desktop\Training Labs\HubVNET"

# Get all Bicep files in the directory
$bicepFiles = Get-ChildItem -Path $bicepDirectory -Filter *.bicep

# Loop through each Bicep file and compile it to JSON
foreach ($bicepFile in $bicepFiles) {
    $jsonOutputPath = [System.IO.Path]::ChangeExtension($bicepFile.FullName, ".json")
    az bicep build $bicepFile.FullName --outdir $bicepDirectory
    Write-Output "Compiled $($bicepFile.Name) to $jsonOutputPath"
}