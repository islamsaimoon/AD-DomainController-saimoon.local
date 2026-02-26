# Active Directory Project Report: Domain Controller Setup (saimoon.local)

## 1. Introduction

This report demonstrates the deployment of a Windows Server **2022** Domain Controller using Active Directory Domain Services (AD DS).  The domain configured for this project is **saimoon.local**.  It includes design, implementation, verification and evidence (screenshots and command outputs).  If you follow these steps and capture the evidence requested in the [Screenshot Checklist](02-Screenshots-Checklist.md) you will have a complete record of your deployment.

## 2. Objectives

- Install the AD DS role and required features on a Windows Server 2022 machine.
- Promote the server to Domain Controller and create a new forest: **saimoon.local**.
- Configure DNS and validate name resolution.
- Create Organizational Units (OUs), users and groups.
- Join a client PC to the domain.
- Apply and test a simple Group Policy Object (GPO).
- Verify services, DNS health and domain functionality.

## 3. Tools & Environment

### 3.1 Software

- **Windows Server 2022** Standard or Datacenter edition (for the Domain Controller).
- **Windows 10 or Windows 11** (for the client PC).
- Management tools: Server Manager, Active Directory Users and Computers (ADUC), DNS Manager, Group Policy Management Console (GPMC) and PowerShell.

### 3.2 Suggested Lab IP Plan

You can customise the addressing to your environment.  A typical lab uses a simple private network:

| Host | IP / Prefix | Notes |
| --- | --- | --- |
| DC1 (Server 2022) | `192.168.10.10/24` | Static IP on the domain controller |
| Gateway | `192.168.10.1` | Router/Internet gateway (if needed) |
| DNS | `192.168.10.10` | DC1 points to itself for DNS |
| CL1 (Client) | `DHCP` or static (same subnet) | DNS must point to 192.168.10.10 |

> **Tip:** Replace these IPs with your actual lab IPs in your screenshots; consistency matters when demonstrating your project.

## 4. Architecture & Diagrams

### 4.1 Physical/Network Diagram

The network diagram illustrates the single‑subnet lab environment with the domain controller and a client machine.  See [`docs/diagrams/network-diagram.mmd`](diagrams/network-diagram.mmd) for the Mermaid source.

### 4.2 Logical AD Diagram

The logical diagram shows the forest, domain, OUs, groups and sample users.  See [`docs/diagrams/ad-logical-diagram.mmd`](diagrams/ad-logical-diagram.mmd) for the Mermaid source.

### 4.3 GPO Login Flow Diagram

The GPO sequence diagram outlines the process when a domain user logs in and receives policies.  See [`docs/diagrams/gpo-login-flow.mmd`](diagrams/gpo-login-flow.mmd).

## 5. Implementation Steps

This section describes the step‑by‑step actions you need to perform.  Capture evidence at each step as described in the [Screenshot Checklist](02-Screenshots-Checklist.md).

### Step 1: Prepare the Domain Controller Server (DC1)

1. Install Windows Server 2022 and log in as the local **Administrator**.
2. Set the server hostname to **DC1** (System → About → Rename this PC).
3. Configure a static IP address and set the preferred DNS server to the server’s own IP (e.g. 192.168.10.10).  Ensure default gateway is set if Internet access is required.
4. Reboot if prompted.

**Evidence (Screenshots):**
- Network adapter IPv4 settings showing static IP and DNS.
- System Properties showing computer name **DC1**.

### Step 2: Install the AD DS Role

1. Launch **Server Manager**.
2. Choose **Add Roles and Features**.
3. Select **Active Directory Domain Services**.  Accept the required features and continue.
4. Complete the wizard to install the role.  Do not close Server Manager.

**Evidence:**
- Screen showing the AD DS role selected.
- Installation progress or success summary page.

### Step 3: Promote the Server to Domain Controller

1. In Server Manager’s flag notifications, click **Promote this server to a domain controller**.
2. Choose **Add a new forest**.
3. Enter **saimoon.local** as the **Root domain name**.
4. Specify a **DSRM password** (Directory Services Restore Mode).  Record this in a secure place.
5. Continue through the wizard.  Review and ensure the prerequisites check passes, then install.
6. The server will reboot automatically to complete promotion.  After reboot, log in using the domain administrator account (e.g. SAIMOON\Administrator).

**Evidence:**
- “Add a new forest” screen showing `saimoon.local`.
- Prerequisites check passed screen.
- Post‑restart logon screen showing the **SAIMOON** domain (domain drop‑down in login screen or server information).

### Step 4: Validate DNS and AD Core Components

After DC1 restarts as a domain controller:

1. Open **DNS Manager** (from Server Manager → Tools → DNS).
2. Expand the server node and then **Forward Lookup Zones**.  Verify that the zone **saimoon.local** exists along with the **_msdcs.saimoon.local** subzone.
3. Under `_tcp` and `_udp` folders of **saimoon.local**, verify the presence of SRV records (e.g. Kerberos, LDAP, etc.).
4. Check the host (A) record for **DC1** in the root of the zone.

**Evidence:**
- DNS zones showing `saimoon.local` and `_msdcs.saimoon.local`.
- SRV records under `_tcp`.

### Step 5: Create OUs, Users and Groups

Use **Active Directory Users and Computers (ADUC)** to organise your directory.

1. Create an OU structure.  For example:
   - `OU=Departments`
     - `OU=IT`
     - `OU=HR`
     - `OU=Finance`
2. Create global security groups inside each OU:
   - `IT‑Admins`
   - `HR‑Users`
   - `Finance‑Users`
3. Create test user accounts:
   - `it.user1` (located in `OU=IT`)
   - `hr.user1` (located in `OU=HR`)
   - `finance.user1` (located in `OU=Finance`)
4. Add each user to the appropriate group.

**Evidence:**
- ADUC showing the OU hierarchy.
- Properties of a user showing membership in the correct group.

### Step 6: Join Client PC (CL1) to the Domain

On the Windows 10/11 client (CL1):

1. Configure the client’s DNS settings to point to DC1’s IP (e.g. 192.168.10.10).  Without this, the client cannot locate the domain controller.
2. Open **System Properties** → **About** → **Rename this PC (advanced)** → **Change**.  Select **Domain** and enter **saimoon.local**.
3. When prompted for credentials, supply domain administrator credentials (e.g. `SAIMOON\Administrator`).
4. After the welcome message confirms the computer has joined the domain, reboot the client.
5. Sign in using a domain user (e.g. `SAIMOON\it.user1`).

**Evidence:**
- Client DNS settings showing DNS server set to DC1.
- “Welcome to the saimoon.local domain” confirmation dialog.
- System information showing domain membership.
- Successful login as a domain user (desktop after login).

### Step 7: Apply a Sample GPO and Verify

To demonstrate Group Policy, create a simple policy that affects a specific OU.  Example: block Control Panel for HR users.

1. Open **Group Policy Management Console (GPMC)** on DC1.
2. Right‑click the **HR** OU and choose **Create a GPO in this domain, and Link it here…**.
3. Name the GPO `HR‑Policy` and click **OK**.
4. Edit the GPO: navigate to **User Configuration → Policies → Administrative Templates → Control Panel** and enable **Prohibit access to Control Panel and PC settings**.
5. On an HR user’s client session (logged in as `hr.user1`), run `gpupdate /force` to ensure the policy is applied immediately.
6. Attempt to open Control Panel; it should be blocked.

**Evidence:**
- GPMC showing the GPO linked to the HR OU.
- Screenshot of the policy setting enabled.
- Command prompt output from `gpupdate /force`.
- Proof that Control Panel is blocked for the HR user (error message or greyed out icon).

### Step 8: Collect Verification Evidence

Use the commands listed in [`docs/03-Verification-Commands.md`](03-Verification-Commands.md) to collect output that verifies the health of the Domain Controller and client configuration.  Include the outputs in the **Results** section below and attach the log files (e.g. `dcdiag_report.txt`) if produced.

## 6. Results

Record the key results of your deployment here.  Include summaries such as:

- Domain **saimoon.local** was created successfully on Windows Server 2022.
- DC1 provides AD DS and DNS services.
- Organisational structure (OUs, users and groups) implemented as designed.
- Client CL1 successfully joined the domain and logged in with a domain user.
- Group Policy applied correctly to the HR OU and prevented access to Control Panel.

Add any verification outputs (command snippets) demonstrating service status, DNS resolution and replication health.

## 7. Conclusion

This project demonstrates how to deploy a Windows Server 2022 Domain Controller with integrated DNS and Active Directory Domain Services.  By following the structured steps and capturing evidence, you can show proficiency in configuring a domain environment, managing objects, joining clients and enforcing Group Policy.  The scripts included in this repository automate portions of the deployment and verification, while the diagrams provide a clear understanding of the network and directory structure.

## 8. Appendix

- **Screenshots:** See the `screenshots/` folder.
- **Command Outputs:** Included in the **Results** section above.
- **Scripts:** Stored in the `scripts/` folder.