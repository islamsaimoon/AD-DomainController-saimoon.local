<#
    client-join.ps1

    This script joins a Windows client to the domain `saimoon.local`.  Run it on the
    client computer as an administrator.  Ensure the client’s DNS is set to the
    domain controller’s IP address before running.
#>

param (
    [string]$DomainName = "saimoon.local",
    [string]$DomainUser = "SAIMOON\Administrator"
)

Write-Host "Joining the computer to domain $DomainName..." -ForegroundColor Cyan
Add-Computer -DomainName $DomainName -Credential (Get-Credential -UserName $DomainUser -Message "Enter domain admin credentials") -Force -Restart

Write-Host "Domain join initiated.  The client will reboot automatically." -ForegroundColor Green