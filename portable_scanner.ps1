Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

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

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Nmap Scanner"
$form.Size = New-Object System.Drawing.Size(400, 400)
$form.StartPosition = "CenterScreen"

# Create the label for the target domain
$labelDomain = New-Object System.Windows.Forms.Label
$labelDomain.Text = "Enter the target domain:"
$labelDomain.Location = New-Object System.Drawing.Point(10, 20)
$labelDomain.Size = New-Object System.Drawing.Size(130, 20)
$form.Controls.Add($labelDomain)

# Create the text box for the target domain
$textBoxDomain = New-Object System.Windows.Forms.TextBox
$textBoxDomain.Location = New-Object System.Drawing.Point(150, 20)
$textBoxDomain.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxDomain)

# Create the label for the port
$labelPort = New-Object System.Windows.Forms.Label
$labelPort.Text = "Enter the port:"
$labelPort.Location = New-Object System.Drawing.Point(10, 60)
$labelPort.Size = New-Object System.Drawing.Size(130, 20)
$form.Controls.Add($labelPort)

# Create the text box for the port
$textBoxPort = New-Object System.Windows.Forms.TextBox
$textBoxPort.Location = New-Object System.Drawing.Point(150, 60)
$textBoxPort.Size = New-Object System.Drawing.Size(200, 20)
$textBoxPort.Text = "443"
$form.Controls.Add($textBoxPort)

# Create the first set of radio buttons for scan type
$groupBox1 = New-Object System.Windows.Forms.GroupBox
$groupBox1.Text = "Scan Type"
$groupBox1.Size = New-Object System.Drawing.Size(350, 80)
$groupBox1.Location = New-Object System.Drawing.Point(20, 100)

$radioSSL = New-Object System.Windows.Forms.RadioButton
$radioSSL.Text = "SSL"
$radioSSL.Location = New-Object System.Drawing.Point(10, 20)
$groupBox1.Controls.Add($radioSSL)

$radioVuln = New-Object System.Windows.Forms.RadioButton
$radioVuln.Text = "VULN"
$radioVuln.Location = New-Object System.Drawing.Point(10, 50)
$groupBox1.Controls.Add($radioVuln)

$form.Controls.Add($groupBox1)

# Define a common size for both buttons
$buttonSize = New-Object System.Drawing.Size(160, 30)

# Create the scan button
$buttonScan = New-Object System.Windows.Forms.Button
$buttonScan.Text = "Scan"
$buttonScan.Location = New-Object System.Drawing.Point(20, 300)
$buttonScan.Size = $buttonSize
$form.Controls.Add($buttonScan)

# Create the button to close the form
$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Text = "Close"
$buttonClose.Location = New-Object System.Drawing.Point(200, 300)
$buttonClose.Size = $buttonSize
$form.Controls.Add($buttonClose)

# Define the action for the scan button
$buttonScan.Add_Click({
    $targetDomain = $textBoxDomain.Text
    $port = $textBoxPort.Text
    $scanType = if ($radioSSL.Checked) { "ssl" } elseif ($radioVuln.Checked) { "vuln" } else { "" }

    if ($scanType -eq "ssl") {
        Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "`"$nmap -p $port --script ssl-enum-ciphers $targetDomain`""
    } elseif ($scanType -eq "vuln") {
        Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "`"$nmap -p $port --script vuln $targetDomain`""
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a scan type.")
    }
})

# Define the action for the close button, including cleanup options
$buttonClose.Add_Click({
    # Ask for cleanup options
    $dialogResult = [System.Windows.Forms.MessageBox]::Show("Would you like to delete the temporary files?", "Cleanup", "YesNo")
    
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::Yes) {
        Remove-Item -Path $downloadPath -Force
        Remove-Item -Path $extractPath -Recurse -Force
        [System.Windows.Forms.MessageBox]::Show("Temporary files deleted. You will have to download nmap.")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Temporary files were not deleted. You will not have to download nmap again.")
    }

    # Close the form
    $form.Close()
})

# Show the form
$form.ShowDialog()
