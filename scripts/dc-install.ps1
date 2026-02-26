<#
    dc-install.ps1

    This script installs the Active Directory Domain Services role on Windows Server 2022
    and promotes the machine to a domain controller for the forest/domain `saimoon.local`.
    Run this script from an elevated PowerShell session.

    Note: You can modify the domain name or NetBIOS name as needed.  The `-Force`
    parameter suppresses confirmation prompts.
#>

Import-Module ServerManager

Write-Host "Installing Active Directory Domain Services role..." -ForegroundColor Cyan
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Write-Host "Promoting server to domain controller for saimoon.local..." -ForegroundColor Cyan
Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName "saimoon.local" `
    -DomainNetbiosName "SAIMOON" `
    -InstallDNS `
    -SafeModeAdministratorPassword (Read-Host -AsSecureString "Enter DSRM password") `
    -Force

Write-Host "Domain controller promotion initiated.  The server will reboot automatically." -ForegroundColor Green