$profileListKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'
$subkeys = Get-ChildItem $profileListKey

foreach ($subkey in $subkeys) {
    $profilePath = (Get-ItemProperty $subkey.PSPath).ProfileImagePath
    if ($profilePath -like "*DefaultUser*" -and -not (Test-Path $profilePath)) {
        try {
            Remove-Item -Path $subkey.PSPath -Recurse -Force
            Write-Output "Removed registry entry for profile: $profilePath"
        } catch {
            Write-Warning "Failed to remove registry key for $profilePath: $($_.Exception.Message)"
        }
    }
}
