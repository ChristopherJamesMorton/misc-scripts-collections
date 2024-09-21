$programs = Get-Content "C:\installed_programs.txt"
$uwpApps = Get-Content "C:\installed_uwp_apps.txt"

foreach ($program in $programs) {
    $programName = $program.Split(' ')[0]
    choco install $programName -y
}

foreach ($app in $uwpApps) {
    $appName = $app.Split(' ')[0]
    Add-AppxPackage -Path $appName
}
