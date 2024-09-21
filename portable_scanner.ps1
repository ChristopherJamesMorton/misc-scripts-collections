# Define the URL for the portable Nmap download
$nmapUrl = "https://nmap.org/dist/nmap-7.92-win32.zip"
$downloadPath = "$env:TEMP\nmap.zip"
$extractPath = "$env:TEMP\nmap"
$nmap = "$extractPath\nmap-7.92\nmap.exe"

# Check if Nmap is already downloaded and extracted
if (-Not (Test-Path -Path $nmap)) {
    # Download the Nmap zip file
    Invoke-WebRequest -Uri $nmapUrl -OutFile $downloadPath

    # Extract the zip file
    Expand-Archive -Path $downloadPath -DestinationPath $extractPath
}

# Prompt for the target domain and port
$targetDomain = Read-Host "Enter the target domain"
$port = Read-Host "Enter the port (default is 443)" -DefaultValue 443

# Ensure the port is set to 443 if no input is provided
if (-Not $port) {
    $port = 443
}

# Prompt for the type of scan
$scanType = Read-Host "Enter the type of scan (ssl/vuln)"

# Run the selected scan
if ($scanType -eq "ssl") {
    & $nmap -p $port --script ssl-enum-ciphers $targetDomain
} elseif ($scanType -eq "vuln") {
    & $nmap -p $port --script vuln $targetDomain
} else {
    Write-Host "Invalid scan type selected."
}

# Ask for confirmation before cleaning up temporary files
$cleanup = Read-Host "Do you want to clean up the temporary files? (yes/no)"
if ($cleanup -eq "yes") {
    Remove-Item -Path $downloadPath -Force
    Remove-Item -Path $extractPath -Recurse -Force
} else {
    Write-Host "Temporary files were not deleted."
}
