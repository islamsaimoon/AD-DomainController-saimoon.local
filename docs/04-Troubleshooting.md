# Troubleshooting Guide

This section provides guidance on resolving common issues you may encounter while configuring your Active Directory environment.  Always consult official Microsoft documentation for detailed troubleshooting steps.

## 1. Cannot Promote Server to Domain Controller

- **Issue:** Promotion wizard fails or prerequisites check reports errors.
- **Resolution:**
  - Ensure the server has a static IP address and proper DNS configuration (preferred DNS should point to itself).
  - Verify the correct **.NET Framework** features are installed (Server Manager adds these automatically when selecting AD DS).
  - Check the event logs for **Directory Services** or **DNS Server** for specific error messages.
  - Make sure the DSRM password meets complexity requirements.

## 2. Client Cannot Join Domain

- **Issue:** Client returns “The specified domain either does not exist or could not be contacted.”
- **Resolution:**
  - Confirm the client’s DNS server points to the domain controller’s IP.  Incorrect DNS is the most common cause.
  - Ensure there is network connectivity between the client and DC (ping the DC by IP and by name).
  - Verify that the domain controller’s firewall allows inbound LDAP, Kerberos and DNS traffic (these should be open by default when promoting to domain controller).

## 3. GPO Not Applying

- **Issue:** Policies do not appear to be applied to users or computers.
- **Resolution:**
  - Run `gpupdate /force` and then `gpresult /r` to confirm which policies are applied.  The report will list the winning GPOs.
  - Ensure the GPO is linked to the correct OU and that inheritance is not blocked.
  - Check the policy’s **Security Filtering** and **WMI filtering** settings to verify the object meets the criteria.
  - Look for replication delays if multiple DCs exist; run `repadmin /replsummary` to confirm replication is healthy.

## 4. DNS Resolution Fails

- **Issue:** `nslookup` returns timeouts or incorrect results.
- **Resolution:**
  - Use **DNS Manager** to verify that the **saimoon.local** zone and its records exist.  The host (A) and SRV records must be present.
  - Ensure the DNS service is running on the domain controller (`Get-Service DNS`).
  - Clear the DNS cache on the client (`ipconfig /flushdns`) and on the server (`Clear-DnsServerCache` in PowerShell).
  - If you made changes to the zone, increment the zone’s serial number so changes replicate properly.

## 5. Time Synchronisation Issues

- **Issue:** Kerberos authentication errors caused by time skew between computers.
- **Resolution:**
  - Confirm that the **Windows Time** service (`W32Time`) is running on the domain controller and clients.
  - Domain members automatically synchronise with the domain hierarchy.  If necessary, re‑sync using `w32tm /resync`.
  - Verify the domain controller has the correct time source (e.g. an external NTP server or BIOS clock).

## 6. DSRM Password Forgotten

- **Issue:** You need to perform Directory Services Restore Mode tasks but cannot recall the DSRM password.
- **Resolution:**
  - Log on with a domain admin account and reset the DSRM password using:
    ```
    ntdsutil "set dsrm password" "reset password on server <ServerName>" "quit" "quit"
    ```
  - Enter and confirm the new DSRM password when prompted.

## 7. Additional Resources

- [Active Directory documentation on Microsoft Learn](https://learn.microsoft.com/windows-server/identity/active-directory-domain-services/)
- [Troubleshooting AD replication issues](https://learn.microsoft.com/troubleshoot/windows-server/identity/troubleshooting-active-directory-replication-problems)

Keep these resources handy to diagnose more complex problems that may occur.