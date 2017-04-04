
$t = Get-Service | Where-Object {$_.StartType -match "auto"}

#Some comment here 
if ($env:COMPUTERNAME -eq "OFFICE-LAPTOP") {Write-Host "Match computer name $env:COMPUTERNAME"}
else {
    if (Test-Path $env:SystemDrive) {
        Write-Output "$env:SystemDrive exists"
    }
    Write-Host "Fail"
}

Get-Process
Write-Host "This is a statement"
#something 


Get-Acl C:\Windows\Temp
