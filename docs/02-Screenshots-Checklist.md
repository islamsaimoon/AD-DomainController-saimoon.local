# Screenshot Checklist (Evidence)

Use this checklist to ensure you capture all required screenshots during your deployment.  Place the image files in the `screenshots/` directory and name them sequentially (e.g. `01-ip-config.png`, `02-hostname.png`, etc.).  Adjust numbers if you add additional evidence.

## A) Server Preparation (DC1)

1. **Static IP & DNS settings** — IPv4 properties window showing the static IP address and DNS pointing to DC1.
2. **Computer name (hostname)** — System Properties window showing the name set to **DC1**.
3. **Server Manager Dashboard** — Before adding roles, showing default Server Manager.

## B) AD DS Installation

4. **Add Roles and Features Wizard** — Step where the **Active Directory Domain Services** role is selected.
5. **Installation Success** — Completion page confirming the role installed successfully.

## C) Domain Controller Promotion

6. **Add a new forest** — Screen showing `saimoon.local` entered as the root domain name.
7. **Prerequisites check** — Summary screen indicating that all prerequisite checks passed.
8. **Post‑restart login** — Windows logon screen showing the domain selection drop‑down or the **SAIMOON** domain listed in sign‑in information.

## D) DNS Validation

9. **Forward Lookup Zones** — DNS Manager showing `saimoon.local` and `_msdcs.saimoon.local` zones.
10. **SRV Records** — `saimoon.local/_tcp` folder displaying Kerberos and LDAP SRV records.
11. **Host (A) record** — The A record for **DC1** in the root of the `saimoon.local` zone.

## E) AD Objects

12. **OU structure** — ADUC console showing the Departments OU and its child OUs (IT, HR, Finance).
13. **User account details** — Properties window of a sample user (e.g. `it.user1`).
14. **Group membership** — The “Member Of” tab for a user, showing membership in the correct group.

## F) Client Join

15. **Client DNS settings** — Network settings on CL1 showing DNS server pointing to DC1.
16. **Domain join success** — “Welcome to the saimoon.local domain” message after joining.
17. **System properties** — On CL1, the “Computer Name/Domain Changes” window showing membership in the **saimoon.local** domain.
18. **Login as domain user** — Windows sign‑in with domain user credentials and successful desktop load.

## G) GPO Verification

19. **GPO linked** — Group Policy Management Console showing `HR‑Policy` linked to the HR OU.
20. **GPO setting** — Editor view of the policy enabling “Prohibit access to Control Panel and PC settings”.
21. **gpupdate output** — Command prompt output from running `gpupdate /force` on the HR user’s session.
22. **Policy applied** — Attempt to open Control Panel resulting in an error or restriction for HR user.

## H) Health & Command Proof

23. **ipconfig /all** — Output on DC1 showing IP configuration and DNS server.
24. **nslookup** — Proof that DC1 resolves `saimoon.local` and `dc1.saimoon.local` correctly.
25. **dcdiag summary** — Relevant portion of the `dcdiag` report showing no errors.
26. **repadmin** — Output from `repadmin /replsummary` and `repadmin /showrepl` (if multiple DCs are present; otherwise note minimal output).

Use additional screenshots if necessary to prove other custom configurations or troubleshooting steps.