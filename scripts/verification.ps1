<#
    verification.ps1

    This script performs several basic checks on the domain controller to verify
    Active Directory health and DNS functionality.  Run it from an elevated
    PowerShell prompt on DC1.
#>

Write-Host "=== Domain / Forest Information ===" -ForegroundColor Cyan
Get-ADDomain
Get-ADForest
Get-ADDomainController -Filter *

Write-Host "\n=== Essential Services Status ===" -ForegroundColor Cyan
Get-Service NTDS, DNS, Netlogon, KDC, W32Time | Select Name, Status, StartType | Format-Table -AutoSize

Write-Host "\n=== DNS Resolution Checks ===" -ForegroundColor Cyan
nslookup saimoon.local
nslookup dc1.saimoon.local

Write-Host "\n=== DCDIAG DNS Test ===" -ForegroundColor Cyan
dcdiag /test:dns

Write-Host "\nScript completed.  Review the outputs above for any errors." -ForegroundColor Green