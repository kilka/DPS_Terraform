# Backup security group for Dell AVE/DDVE (combined)
# NOTE: This security group contains all required ports for backup communication
# between on-premises and AWS backup infrastructure per the Dell backup ports specification
# Reference: aws_backup_ports_generic_csv.csv

resource "aws_security_group" "backup" {
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "Backup"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# INBOUND RULES - From On-Premises Backup CIDR to AWS
# ============================================================================

# Echo/Registration (TCP 7) - Echo/Registration between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_echo_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7
  to_port           = 7
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Echo/Registration between on-prem DD/Avamar"
}

# SSH (TCP 22) - SSH between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_ssh" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SSH between on-prem DD/Avamar"
}

# RPC Portmapper (TCP 111) - RPC Portmapper TCP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_rpc_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "RPC Portmapper TCP between on-prem DD/Avamar"
}

# RPC Portmapper (UDP 111) - RPC Portmapper UDP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_rpc_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "RPC Portmapper UDP between on-prem DD/Avamar"
}

# HTTPS (TCP 443) - HTTPS between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_https" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "HTTPS between on-prem DD/Avamar"
}

# Admin service (TCP 700) - Admin service between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_admin_700" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 700
  to_port           = 700
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service between on-prem DD/Avamar"
}

# NFS (TCP 2049) - NFS TCP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_nfs_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS TCP between on-prem DD/Avamar"
}

# NFS (UDP 2049) - NFS UDP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_nfs_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS UDP between on-prem DD/Avamar"
}

# DD Replication (TCP 2051) - DD Replication between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_dd_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2051
  to_port           = 2051
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DD Replication between on-prem DD/Avamar"
}

# NFS mountd (TCP 2052) - NFS mountd TCP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_nfs_mountd_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS mountd TCP between on-prem DD/Avamar"
}

# NFS mountd (UDP 2052) - NFS mountd UDP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_nfs_mountd_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS mountd UDP between on-prem DD/Avamar"
}

# Archive tier (TCP 3008) - Archive tier between on-prem DD/Avamar (optional)
resource "aws_security_group_rule" "onprem_archive_tier" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 3008
  to_port           = 3008
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Archive tier between on-prem DD/Avamar (optional)"
}

# SMS/System management (TCP 3009) - SMS/System management between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_sms" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 3009
  to_port           = 3009
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SMS/System management between on-prem DD/Avamar"
}

# Update Manager/Installation Manager (TCP 7543) - Update Manager/Installation Manager between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_update_mgr" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7543
  to_port           = 7543
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Update Manager/Installation Manager between on-prem DD/Avamar"
}

# Admin services (TCP 7778-7781) - Admin services between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_admin_7778" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7778
  to_port           = 7781
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin services between on-prem DD/Avamar"
}

# Admin service (TCP 8443) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "onprem_admin_8443" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "App/Service to management tools (vCenter/BRM)"
}

# Admin service (TCP 8543) - Admin service between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_admin_8543" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8543
  to_port           = 8543
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service between on-prem DD/Avamar"
}

# App/Service (TCP 8888) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "onprem_app_8888" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8888
  to_port           = 8888
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "App/Service to management tools (vCenter/BRM)"
}

# Admin service (TCP 9090) - Admin service between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_admin_9090" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service between on-prem DD/Avamar"
}

# AUI/Replication (TCP 9443) - AUI/Replication between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_aui_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "AUI/Replication between on-prem DD/Avamar"
}

# SNMP (TCP 161-163) - SNMP TCP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_snmp_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 163
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SNMP TCP between on-prem DD/Avamar"
}

# SNMP (UDP 161-163) - SNMP UDP between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_snmp_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 163
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SNMP UDP between on-prem DD/Avamar"
}

# Legacy connections (TCP 27000) - Legacy connections between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_legacy" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 27000
  to_port           = 27000
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Legacy connections between on-prem DD/Avamar"
}

# MCS replication (TCP 28001-28010) - MCS replication between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_mcs_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 28001
  to_port           = 28010
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "MCS replication between on-prem DD/Avamar"
}

# Internal agents (TCP 28810-28819) - Internal agents between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_internal_agents" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 28810
  to_port           = 28819
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Internal agents between on-prem DD/Avamar"
}

# SSL data path (TCP 29000) - SSL data path between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_ssl_data" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 29000
  to_port           = 29000
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SSL data path between on-prem DD/Avamar"
}

# MCS/Avagent SSL (TCP 30001-30010) - MCS/Avagent SSL between on-prem DD/Avamar
resource "aws_security_group_rule" "onprem_mcs_avagent_ssl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 30001
  to_port           = 30010
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "MCS/Avagent SSL between on-prem DD/Avamar"
}

# ============================================================================
# INBOUND RULES - From On-Premises Management Host
# ============================================================================

# Management Host SSH (TCP 22) - Management Host ssh
resource "aws_security_group_rule" "mgmt_ssh" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host ssh"
}

# Management Host Web GUI (TCP 443) - Management Host web gui
resource "aws_security_group_rule" "mgmt_web_gui" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host web gui"
}

# Management Host AVI (TCP 1234) - Management Host AVI
resource "aws_security_group_rule" "mgmt_avi" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 1234
  to_port           = 1234
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host AVI"
}

# Management Host AVI/SSL (TCP 7543) - Management Host AVI/SSL
resource "aws_security_group_rule" "mgmt_avi_ssl" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7543
  to_port           = 7543
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host AVI/SSL"
}

# Management Host Avamar Console (TCP 7778-7781) - Management Host Avamar Console
resource "aws_security_group_rule" "mgmt_avamar_console" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7778
  to_port           = 7781
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host Avamar Console"
}

# Management Host AVI Downloader (TCP 8580) - Management Host AVI Downloader
resource "aws_security_group_rule" "mgmt_avi_downloader" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8580
  to_port           = 8580
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host AVI Downloader"
}

# Management Host GUI/SSL (TCP 9443) - Management Host GUI / SSL
resource "aws_security_group_rule" "mgmt_gui_ssl" {
  count             = length(var.onprem_mgmt_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_mgmt_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Management Host GUI / SSL"
}

# ============================================================================
# INBOUND RULES - From DPA Server/Agent
# ============================================================================

# DPA SSH (TCP 22) - DPA SSH
resource "aws_security_group_rule" "dpa_ssh" {
  count             = length(var.dpa_server_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.dpa_server_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DPA SSH"
}

# DPA SNMP (UDP 161) - DPA SNMP
resource "aws_security_group_rule" "dpa_snmp" {
  count             = length(var.dpa_server_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  cidr_blocks       = var.dpa_server_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DPA SNMP"
}

# DPA Data Collection (TCP 5555) - DPA Data Collection
resource "aws_security_group_rule" "dpa_data_collection" {
  count             = length(var.dpa_server_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 5555
  to_port           = 5555
  protocol          = "tcp"
  cidr_blocks       = var.dpa_server_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DPA Data Collection"
}

# DPA Rest API (TCP 8443) - DPA Rest API
resource "aws_security_group_rule" "dpa_rest_api" {
  count             = length(var.dpa_server_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = var.dpa_server_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DPA Rest API"
}

# ============================================================================
# OUTBOUND RULES - From AWS to On-Premises Backup CIDR
# ============================================================================

# Echo/Registration (TCP 7) - Echo/Registration to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_echo_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 7
  to_port           = 7
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Echo/Registration to on-prem DD/Avamar"
}

# SSH (TCP 22) - SSH to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_ssh" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SSH to on-prem DD/Avamar"
}

# RPC Portmapper (TCP 111) - RPC Portmapper TCP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_rpc_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "RPC Portmapper TCP to on-prem DD/Avamar"
}

# RPC Portmapper (UDP 111) - RPC Portmapper UDP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_rpc_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "RPC Portmapper UDP to on-prem DD/Avamar"
}

# HTTPS (TCP 443) - HTTPS to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_https" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "HTTPS to on-prem DD/Avamar"
}

# Admin service (TCP 700) - Admin service to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_admin_700" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 700
  to_port           = 700
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service to on-prem DD/Avamar"
}

# NFS (TCP 2049) - NFS TCP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_nfs_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS TCP to on-prem DD/Avamar"
}

# NFS (UDP 2049) - NFS UDP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_nfs_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS UDP to on-prem DD/Avamar"
}

# DD Replication (TCP 2051) - DD Replication to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_dd_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 2051
  to_port           = 2051
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "DD Replication to on-prem DD/Avamar"
}

# NFS mountd (TCP 2052) - NFS mountd TCP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_nfs_mountd_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS mountd TCP to on-prem DD/Avamar"
}

# NFS mountd (UDP 2052) - NFS mountd UDP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_nfs_mountd_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "NFS mountd UDP to on-prem DD/Avamar"
}

# Archive tier (TCP 3008) - Archive tier to on-prem DD/Avamar (optional)
resource "aws_security_group_rule" "to_onprem_archive_tier" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 3008
  to_port           = 3008
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Archive tier to on-prem DD/Avamar (optional)"
}

# SMS/System management (TCP 3009) - SMS/System management to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_sms" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 3009
  to_port           = 3009
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SMS/System management to on-prem DD/Avamar"
}

# Update Manager/Installation Manager (TCP 7543) - Update Manager/Installation Manager to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_update_mgr" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 7543
  to_port           = 7543
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Update Manager/Installation Manager to on-prem DD/Avamar"
}

# Admin services (TCP 7778-7781) - Admin services to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_admin_7778" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 7778
  to_port           = 7781
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin services to on-prem DD/Avamar"
}

# Admin service (TCP 8443) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "to_onprem_admin_8443" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "App/Service to management tools (vCenter/BRM)"
}

# Admin service (TCP 8543) - Admin service to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_admin_8543" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 8543
  to_port           = 8543
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service to on-prem DD/Avamar"
}

# App/Service (TCP 8888) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "to_onprem_app_8888" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 8888
  to_port           = 8888
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "App/Service to management tools (vCenter/BRM)"
}

# Admin service (TCP 9090) - Admin service to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_admin_9090" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Admin service to on-prem DD/Avamar"
}

# AUI/Replication (TCP 9443) - AUI/Replication to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_aui_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "AUI/Replication to on-prem DD/Avamar"
}

# SNMP (TCP 161-163) - SNMP TCP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_snmp_tcp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 161
  to_port           = 163
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SNMP TCP to on-prem DD/Avamar"
}

# SNMP (UDP 161-163) - SNMP UDP to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_snmp_udp" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 161
  to_port           = 163
  protocol          = "udp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SNMP UDP to on-prem DD/Avamar"
}

# Legacy connections (TCP 27000) - Legacy connections to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_legacy" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 27000
  to_port           = 27000
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Legacy connections to on-prem DD/Avamar"
}

# MCS replication (TCP 28001-28010) - MCS replication to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_mcs_repl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 28001
  to_port           = 28010
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "MCS replication to on-prem DD/Avamar"
}

# Internal agents (TCP 28810-28819) - Internal agents to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_internal_agents" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 28810
  to_port           = 28819
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "Internal agents to on-prem DD/Avamar"
}

# SSL data path (TCP 29000) - SSL data path to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_ssl_data" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 29000
  to_port           = 29000
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "SSL data path to on-prem DD/Avamar"
}

# MCS/Avagent SSL (TCP 30001-30010) - MCS/Avagent SSL to on-prem DD/Avamar
resource "aws_security_group_rule" "to_onprem_mcs_avagent_ssl" {
  count             = length(var.onprem_backup_cidr_blocks) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 30001
  to_port           = 30010
  protocol          = "tcp"
  cidr_blocks       = var.onprem_backup_cidr_blocks
  security_group_id = aws_security_group.backup.id
  description       = "MCS/Avagent SSL to on-prem DD/Avamar"
}

# ============================================================================
# OUTBOUND RULES - From AWS to External Services
# ============================================================================

# NTP (UDP 123) - NTP to NTP servers
resource "aws_security_group_rule" "to_ntp" {
  count             = length(var.ntp_server_ips) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = [for ip in var.ntp_server_ips : "${ip}/32"]
  security_group_id = aws_security_group.backup.id
  description       = "NTP to NTP servers"
}

# DNS (UDP 53) - DNS to DNS servers
resource "aws_security_group_rule" "to_dns" {
  count             = length(var.dns_server_ips) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [for ip in var.dns_server_ips : "${ip}/32"]
  security_group_id = aws_security_group.backup.id
  description       = "DNS to DNS servers"
}

# SMTP (TCP 25) - SMTP to SMTP servers
resource "aws_security_group_rule" "to_smtp" {
  count             = length(var.smtp_server_ips) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 25
  to_port           = 25
  protocol          = "tcp"
  cidr_blocks       = [for ip in var.smtp_server_ips : "${ip}/32"]
  security_group_id = aws_security_group.backup.id
  description       = "SMTP to SMTP servers"
}

# Dell ESRS (TCP 443) - Dell ESRS
resource "aws_security_group_rule" "to_dell_esrs_443" {
  count             = length(var.dell_esrs_ips) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [for ip in var.dell_esrs_ips : "${ip}/32"]
  security_group_id = aws_security_group.backup.id
  description       = "Dell ESRS (HTTPS)"
}

# Dell ESRS (TCP 8443) - Dell ESRS
resource "aws_security_group_rule" "to_dell_esrs_8443" {
  count             = length(var.dell_esrs_ips) > 0 ? 1 : 0
  type              = "egress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = [for ip in var.dell_esrs_ips : "${ip}/32"]
  security_group_id = aws_security_group.backup.id
  description       = "Dell ESRS"
}

# ============================================================================
# SELF-REFERENCING RULES - Between Devices in Same Security Group
# ============================================================================

# Echo/Registration (TCP 7) - Echo/Registration between backup devices
resource "aws_security_group_rule" "self_echo_tcp_ingress" {
  type                     = "ingress"
  from_port                = 7
  to_port                  = 7
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Echo/Registration between backup devices"
}

resource "aws_security_group_rule" "self_echo_tcp_egress" {
  type                     = "egress"
  from_port                = 7
  to_port                  = 7
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Echo/Registration between backup devices"
}

# SSH (TCP 22) - SSH between backup devices
resource "aws_security_group_rule" "self_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SSH between backup devices"
}

resource "aws_security_group_rule" "self_ssh_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SSH between backup devices"
}

# RPC Portmapper (TCP 111) - RPC Portmapper TCP between backup devices
resource "aws_security_group_rule" "self_rpc_tcp_ingress" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "RPC Portmapper TCP between backup devices"
}

resource "aws_security_group_rule" "self_rpc_tcp_egress" {
  type                     = "egress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "RPC Portmapper TCP between backup devices"
}

# RPC Portmapper (UDP 111) - RPC Portmapper UDP between backup devices
resource "aws_security_group_rule" "self_rpc_udp_ingress" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "RPC Portmapper UDP between backup devices"
}

resource "aws_security_group_rule" "self_rpc_udp_egress" {
  type                     = "egress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "RPC Portmapper UDP between backup devices"
}

# HTTPS (TCP 443) - HTTPS between backup devices
resource "aws_security_group_rule" "self_https_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "HTTPS between backup devices"
}

resource "aws_security_group_rule" "self_https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "HTTPS between backup devices"
}

# Admin service (TCP 700) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_700_ingress" {
  type                     = "ingress"
  from_port                = 700
  to_port                  = 700
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_700_egress" {
  type                     = "egress"
  from_port                = 700
  to_port                  = 700
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

# NFS (TCP 2049) - NFS TCP between backup devices
resource "aws_security_group_rule" "self_nfs_tcp_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS TCP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_tcp_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS TCP between backup devices"
}

# NFS (UDP 2049) - NFS UDP between backup devices
resource "aws_security_group_rule" "self_nfs_udp_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS UDP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_udp_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS UDP between backup devices"
}

# DD Replication (TCP 2051) - DD Replication between backup devices
resource "aws_security_group_rule" "self_dd_repl_ingress" {
  type                     = "ingress"
  from_port                = 2051
  to_port                  = 2051
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "DD Replication between backup devices"
}

resource "aws_security_group_rule" "self_dd_repl_egress" {
  type                     = "egress"
  from_port                = 2051
  to_port                  = 2051
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "DD Replication between backup devices"
}

# NFS mountd (TCP 2052) - NFS mountd TCP between backup devices
resource "aws_security_group_rule" "self_nfs_mountd_tcp_ingress" {
  type                     = "ingress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS mountd TCP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_mountd_tcp_egress" {
  type                     = "egress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS mountd TCP between backup devices"
}

# NFS mountd (UDP 2052) - NFS mountd UDP between backup devices
resource "aws_security_group_rule" "self_nfs_mountd_udp_ingress" {
  type                     = "ingress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS mountd UDP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_mountd_udp_egress" {
  type                     = "egress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "NFS mountd UDP between backup devices"
}

# Archive tier (TCP 3008) - Archive tier between backup devices (optional)
resource "aws_security_group_rule" "self_archive_tier_ingress" {
  type                     = "ingress"
  from_port                = 3008
  to_port                  = 3008
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Archive tier between backup devices (optional)"
}

resource "aws_security_group_rule" "self_archive_tier_egress" {
  type                     = "egress"
  from_port                = 3008
  to_port                  = 3008
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Archive tier between backup devices (optional)"
}

# SMS/System management (TCP 3009) - SMS/System management between backup devices
resource "aws_security_group_rule" "self_sms_ingress" {
  type                     = "ingress"
  from_port                = 3009
  to_port                  = 3009
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SMS/System management between backup devices"
}

resource "aws_security_group_rule" "self_sms_egress" {
  type                     = "egress"
  from_port                = 3009
  to_port                  = 3009
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SMS/System management between backup devices"
}

# Update Manager/Installation Manager (TCP 7543) - Update Manager/Installation Manager between backup devices
resource "aws_security_group_rule" "self_update_mgr_ingress" {
  type                     = "ingress"
  from_port                = 7543
  to_port                  = 7543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Update Manager/Installation Manager between backup devices"
}

resource "aws_security_group_rule" "self_update_mgr_egress" {
  type                     = "egress"
  from_port                = 7543
  to_port                  = 7543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Update Manager/Installation Manager between backup devices"
}

# Admin services (TCP 7778-7781) - Admin services between backup devices
resource "aws_security_group_rule" "self_admin_7778_ingress" {
  type                     = "ingress"
  from_port                = 7778
  to_port                  = 7781
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin services between backup devices"
}

resource "aws_security_group_rule" "self_admin_7778_egress" {
  type                     = "egress"
  from_port                = 7778
  to_port                  = 7781
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin services between backup devices"
}

# Admin service (TCP 8443) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "self_admin_8443_ingress" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

resource "aws_security_group_rule" "self_admin_8443_egress" {
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

# Admin service (TCP 8543) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_8543_ingress" {
  type                     = "ingress"
  from_port                = 8543
  to_port                  = 8543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_8543_egress" {
  type                     = "egress"
  from_port                = 8543
  to_port                  = 8543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

# App/Service (TCP 8888) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "self_app_8888_ingress" {
  type                     = "ingress"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

resource "aws_security_group_rule" "self_app_8888_egress" {
  type                     = "egress"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

# Admin service (TCP 9090) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_9090_ingress" {
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_9090_egress" {
  type                     = "egress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Admin service between backup devices"
}

# AUI/Replication (TCP 9443) - AUI/Replication between backup devices
resource "aws_security_group_rule" "self_aui_repl_ingress" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "AUI/Replication between backup devices"
}

resource "aws_security_group_rule" "self_aui_repl_egress" {
  type                     = "egress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "AUI/Replication between backup devices"
}

# SNMP (TCP 161-163) - SNMP TCP between backup devices
resource "aws_security_group_rule" "self_snmp_tcp_ingress" {
  type                     = "ingress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SNMP TCP between backup devices"
}

resource "aws_security_group_rule" "self_snmp_tcp_egress" {
  type                     = "egress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SNMP TCP between backup devices"
}

# SNMP (UDP 161-163) - SNMP UDP between backup devices
resource "aws_security_group_rule" "self_snmp_udp_ingress" {
  type                     = "ingress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SNMP UDP between backup devices"
}

resource "aws_security_group_rule" "self_snmp_udp_egress" {
  type                     = "egress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SNMP UDP between backup devices"
}

# Legacy connections (TCP 27000) - Legacy connections between backup devices
resource "aws_security_group_rule" "self_legacy_ingress" {
  type                     = "ingress"
  from_port                = 27000
  to_port                  = 27000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Legacy connections between backup devices"
}

resource "aws_security_group_rule" "self_legacy_egress" {
  type                     = "egress"
  from_port                = 27000
  to_port                  = 27000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Legacy connections between backup devices"
}

# MCS replication (TCP 28001-28010) - MCS replication between backup devices
resource "aws_security_group_rule" "self_mcs_repl_ingress" {
  type                     = "ingress"
  from_port                = 28001
  to_port                  = 28010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "MCS replication between backup devices"
}

resource "aws_security_group_rule" "self_mcs_repl_egress" {
  type                     = "egress"
  from_port                = 28001
  to_port                  = 28010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "MCS replication between backup devices"
}

# Internal agents (TCP 28810-28819) - Internal agents between backup devices
resource "aws_security_group_rule" "self_internal_agents_ingress" {
  type                     = "ingress"
  from_port                = 28810
  to_port                  = 28819
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Internal agents between backup devices"
}

resource "aws_security_group_rule" "self_internal_agents_egress" {
  type                     = "egress"
  from_port                = 28810
  to_port                  = 28819
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "Internal agents between backup devices"
}

# SSL data path (TCP 29000) - SSL data path between backup devices
resource "aws_security_group_rule" "self_ssl_data_ingress" {
  type                     = "ingress"
  from_port                = 29000
  to_port                  = 29000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SSL data path between backup devices"
}

resource "aws_security_group_rule" "self_ssl_data_egress" {
  type                     = "egress"
  from_port                = 29000
  to_port                  = 29000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "SSL data path between backup devices"
}

# MCS/Avagent SSL (TCP 30001-30010) - MCS/Avagent SSL between backup devices
resource "aws_security_group_rule" "self_mcs_avagent_ssl_ingress" {
  type                     = "ingress"
  from_port                = 30001
  to_port                  = 30010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "MCS/Avagent SSL between backup devices"
}

resource "aws_security_group_rule" "self_mcs_avagent_ssl_egress" {
  type                     = "egress"
  from_port                = 30001
  to_port                  = 30010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup.id
  security_group_id        = aws_security_group.backup.id
  description              = "MCS/Avagent SSL between backup devices"
}
