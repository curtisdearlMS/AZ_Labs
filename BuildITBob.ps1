# Define the directory containing the Bicep files
$bicepDirectory = "C:\Users\aarosanders\Desktop\Training Labs\"

# Get all Bicep files in the directory and subdirectories, excluding the /Modules folder
$bicepFiles = Get-ChildItem -Path $bicepDirectory -Filter *.bicep -Recurse | Where-Object { $_.FullName -notmatch '\\Modules\\' }

# Loop through each Bicep file and compile it to JSON
foreach ($bicepFile in $bicepFiles) {
    $jsonOutputPath = [System.IO.Path]::ChangeExtension($bicepFile.FullName, ".json")
    $outputDirectory = [System.IO.Path]::GetDirectoryName($bicepFile.FullName)
    az bicep build --file $bicepFile.FullName --outdir $outputDirectory
    Write-Output "Compiled $($bicepFile.Name) to $jsonOutputPath"
}