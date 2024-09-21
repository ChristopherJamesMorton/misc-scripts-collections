##################################################################################
# DiskCleanUp
##################################################################################

## Variables ####

$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace(0xA)

$temp = get-ChildItem "env:\TEMP"
$temp2 = $temp.Value

$WinTemp = "c:\Windows\Temp\*"

# Remove temp files located in "C:\Users\USERNAME\AppData\Local\Temp"
write-Host "Removing junk files in $temp2." -ForegroundColor Magenta
Remove-Item -Recurse "$temp2\*" -Force -Verbose

# Empty Recycle Bin using Clear-RecycleBin (PowerShell 5.0+)
if ($PSVersionTable.PSVersion.Major -ge 5) {
    write-Host "Emptying Recycle Bin." -ForegroundColor Cyan
    Clear-RecycleBin -Force -Verbose
} else {
    write-Host "PowerShell version too old for Clear-RecycleBin. Skipping this step." -ForegroundColor Red
}

# Remove Windows Temp Directory
write-Host "Removing junk files in $WinTemp." -ForegroundColor Green
Remove-Item -Recurse $WinTemp -Force -Verbose

# Run Disk Cleanup Tool
write-Host "Finally, now running Windows Disk Cleanup Tool." -ForegroundColor Cyan
cleanmgr /sagerun:1 | Out-Null

$([char]7)
Sleep 1
$([char]7)
Sleep 1

write-Host "Clean Up Task Finished !!!"
