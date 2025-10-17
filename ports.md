DDVE:
Rule Type	Port/Range	Protocol	Name/Service	Purpose	Source/Destination
Inbound	2051	TCP	DD Replication	Optimized Duplication from on‑prem DD	ONPREM_DD_CIDR/SG
Inbound	2049	TCP	NFS / DD Boost	Data path from AVE	sg-ave (AWS AVE)
Inbound	2052	TCP/UDP	mountd	NFS mount operations from AVE	sg-ave (AWS AVE)
Inbound	111	TCP/UDP	RPC Portmapper	NFS helper for DD Boost (pin if possible)	sg-ave (AWS AVE)
Inbound	7	TCP	Echo (registration)	Initial registration from AVE (optional)	sg-ave (AWS AVE)
Inbound	3009	TCP	SMS (system mgmt)	DDSM/system management (if used)	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	389	TCP/UDP	LDAP	AD/LDAP integration	AD_DC_CIDR (Domain Controllers/KDC/GC)
Inbound	3268	TCP	GC (LDAP)	Global Catalog lookups	AD_DC_CIDR (Domain Controllers/KDC/GC)
Outbound	2051	TCP	DD Replication	Replicate to on‑prem DD (bi‑dir safe)	ONPREM_DD_CIDR/SG
Outbound	389	TCP/UDP	LDAP	AD/LDAP integration	AD_DC_CIDR (Domain Controllers/KDC/GC)
Outbound	3268	TCP	GC (LDAP)	Global Catalog lookups	AD_DC_CIDR (Domain Controllers/KDC/GC)
Outbound	2049	TCP	DD Boost	DDBOOST	ONPREM_DD_CIDR/SG

AVE:
Rule Type	Port/Range	Protocol	Name/Service	Purpose	Source/Destination
Inbound	700	TCP	Internal Service	Product control/service (if used)	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	7543	TCP	Installation Manager (HTTPS)	Avamar Installation/Update Manager	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	7778-7781	TCP	Avamar Console/RMI	Admin console data channels	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	8543	TCP	App/Service Port	Admin/API (product-specific)	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	9090	TCP	REST/API	Product API (if used)	ONPREM_JUMP_CIDR (or sg-jump)
Inbound	9443	TCP	AUI / Replication Target	Web services & inbound replication	ONPREM_JUMP_CIDR (or sg-jump); ONPREM_AVAMAR_CIDR/SG
Inbound	27000	TCP	Avamar Server (unencrypted)	Legacy/unsec data path (avoid; use 29000)	AVAMAR_CLIENTS_CIDR (if applicable)
Inbound	28001-28002	TCP	MCS/CLI/Auth Exchange	Replication auth/key exchange	ONPREM_AVAMAR_CIDR/SG; sg-ave (AWS AVE)
Inbound	28810-28819	TCP	Internal Agents	Internal grid/agent auth (token)	sg-ave (AWS AVE)
Inbound	29000	TCP	Avamar Server (SSL)	Preferred secure data path	AVAMAR_CLIENTS_CIDR (if applicable); sg-ave (AWS AVE)
Inbound	30001-30010	TCP	MCS/Avagent (SSL)	Client/VM proxy/MCS comms	AVAMAR_CLIENTS_CIDR (if applicable); ONPREM_AVAMAR_CIDR/SG; sg-ave (AWS AVE)
Outbound	7	TCP	Echo (DD Registration)	Register DD system (optional after)	sg-ddve (AWS DDVE)
Outbound	22	TCP	SSH to DDVE (optional)	Automation/scripting toward DD	sg-ddve (AWS DDVE)
Outbound	111	TCP/UDP	RPC Portmapper → DDVE	NFS helper for DD Boost	sg-ddve (AWS DDVE)
Outbound	2049	TCP/UDP	NFS/DD Boost → DDVE	Data path to DDVE	sg-ddve (AWS DDVE)
Outbound	2052	TCP/UDP	mountd → DDVE	NFS mount operations	sg-ddve (AWS DDVE)
Outbound	3008	TCP	Archive Tier (optional)	DD Archive tier (if used)	sg-ddve (AWS DDVE)
Outbound	700	TCP			
Outbound	3009	TCP	Archive Tier/Backend (opt)	DD Archive/Reports (if used)	sg-ddve (AWS DDVE)
Outbound	8443	TCP	App/Service (optional)	Product-specific endpoints	MGMT_TOOLS_CIDR (vCenter/BRM/etc.)
Outbound	8888	TCP	App/Service (optional)	Product-specific endpoints	MGMT_TOOLS_CIDR (vCenter/BRM/etc.)
Outbound	9090	TCP	REST/API (optional)	Product API endpoint(s)	MGMT_TOOLS_CIDR (vCenter/BRM/etc.)
Outbound	9443	TCP	AUI/Replication → peer AVE	Replication/migration to target AVE	ONPREM_AVAMAR_CIDR/SG; sg-ave (AWS AVE)
Outbound	27000	TCP	Avamar Server (unencrypted)	Legacy path (avoid; use 29000)	sg-ave (AWS AVE)
Outbound	28001-28010	TCP	Replication Ranges	Replication/auth channels	ONPREM_AVAMAR_CIDR/SG; sg-ave (AWS AVE)
Outbound	29000	TCP	Avamar Server (SSL)	Secure data path	sg-ave (AWS AVE)
Outbound	30001-30010	TCP	MCS/Avagent (SSL)	Client/proxy/MCS comms	ONPREM_AVAMAR_CIDR/SG; sg-ave (AWS AVE)

COMMON:
Rule Type	Port/Range	Protocol	Name/Service	Purpose	Source/Destination
Inbound	22	TCP	SSH (Admin/DPA)	Admin shell access & DPA checks	ONPREM_JUMP_CIDR (or sg-jump); DPA_SERVER_CIDR
Inbound	443	TCP	HTTPS (GUI/DPA)	GUI access; DPA HTTPS checks	ONPREM_JUMP_CIDR (or sg-jump); DPA_SERVER_CIDR
Inbound	163	TCP	SNMP	Monitoring polls from NMS/DPA	MONITORING_NMS_CIDR; DPA_SERVER_CIDR
Inbound	163	UDP	SNMP	Monitoring polls from NMS/DPA	MONITORING_NMS_CIDR; DPA_SERVER_CIDR
Inbound	161	UDP	SNMP (Polls)	Monitoring polls from NMS/DPA	MONITORING_NMS_CIDR; DPA_SERVER_CIDR
Inbound	161	TCP	SNMP (TCP - optional)	Some tools use TCP/161	MONITORING_NMS_CIDR; DPA_SERVER_CIDR
Inbound	ICMP Echo/DestUnreach/TimeExcd	ICMP	Ping/Diag	Basic diagnostics	ONPREM_JUMP_CIDR (or sg-jump); MONITORING_NMS_CIDR
Outbound	53	UDP	DNS	Name resolution	DNS_CIDR / Route53 Resolver
Outbound	123	UDP	NTP	Time sync	NTP_CIDR / Amazon Time Sync
Outbound	25	TCP	SMTP	Alerting via mail relay	SMTP_RELAY_CIDR
Outbound	162	UDP	SNMP Traps	Traps to NMS/DPA	MONITORING_NMS_CIDR; DPA_SERVER_CIDR
Outbound	443	TCP	HTTPS (Egress)	Updates/APIs/cloud endpoints	Approved external services via NAT/Firewall
Outbound (optional)	88	TCP	Kerberos (KDC)	AD/Kerberos auth	AD_DC_CIDR (Domain Controllers/KDC/GC)
Outbound (optional)	5696	TCP	KMIP (AKM)	External key manager	AKM_CIDR (if used)

