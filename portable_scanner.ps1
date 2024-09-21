Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Nmap Scanner"
$form.Size = New-Object System.Drawing.Size(400, 300)
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

# Create the radio buttons for scan type
$radioSSL = New-Object System.Windows.Forms.RadioButton
$radioSSL.Text = "SSL Enumeration"
$radioSSL.Location = New-Object System.Drawing.Point(10, 100)
$radioSSL.Size = New-Object System.Drawing.Size(130, 20)
$form.Controls.Add($radioSSL)

$radioVuln = New-Object System.Windows.Forms.RadioButton
$radioVuln.Text = "Vulnerability Scan"
$radioVuln.Location = New-Object System.Drawing.Point(150, 100)
$radioVuln.Size = New-Object System.Drawing.Size(130, 20)
$form.Controls.Add($radioVuln)

# Create the button to start the scan
$buttonScan = New-Object System.Windows.Forms.Button
$buttonScan.Text = "Start Scan"
$buttonScan.Location = New-Object System.Drawing.Point(10, 140)
$buttonScan.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($buttonScan)

# Create the button to close the form
$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Text = "Close"
$buttonClose.Location = New-Object System.Drawing.Point(150, 140)
$buttonClose.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($buttonClose)

# Create the label for cleanup confirmation
$labelCleanup = New-Object System.Windows.Forms.Label
$labelCleanup.Text = "Do you want to clean up the files?"
$labelCleanup.Location = New-Object System.Drawing.Point(10, 180)
$labelCleanup.Size = New-Object System.Drawing.Size(250, 20)
$form.Controls.Add($labelCleanup)

# Create the radio buttons for cleanup confirmation
$radioYes = New-Object System.Windows.Forms.RadioButton
$radioYes.Text = "Yes"
$radioYes.Location = New-Object System.Drawing.Point(10, 210)
$radioYes.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($radioYes)

$radioNo = New-Object System.Windows.Forms.RadioButton
$radioNo.Text = "No"
$radioNo.Location = New-Object System.Drawing.Point(150, 210)
$radioNo.Size = New-Object System.Drawing.Size(50, 20)
$radioNo.Checked = $true
$form.Controls.Add($radioNo)

# Define the action for the scan button
$buttonScan.Add_Click({
    $targetDomain = $textBoxDomain.Text
    $port = $textBoxPort.Text
    $scanType = if ($radioSSL.Checked) { "ssl" } elseif ($radioVuln.Checked) { "vuln" } else { "" }
    $cleanup = if ($radioYes.Checked) { "yes" } elseif ($radioNo.Checked) { "no" } else { "" }

    if ($scanType -eq "ssl") {
        & $nmap -p $port --script ssl-enum-ciphers $targetDomain
    } elseif ($scanType -eq "vuln") {
        & $nmap -p $port --script vuln $targetDomain
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a scan type.")
    }

    if ($cleanup -eq "yes") {
        Remove-Item -Path $downloadPath -Force
        Remove-Item -Path $extractPath -Recurse -Force
    } elseif ($cleanup -eq "no") {
        [System.Windows.Forms.MessageBox]::Show("Temporary files were not deleted.")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a cleanup option.")
    }
})

# Define the action for the close button
$buttonClose.Add_Click({
    $form.Close()
})

# Show the form
$form.ShowDialog()
