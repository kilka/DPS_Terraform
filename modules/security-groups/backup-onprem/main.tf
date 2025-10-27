# Backup On-Premises Security Group
# This security group handles bidirectional communication with on-premises backup infrastructure
# Includes all ports required for DD/Avamar replication, backup operations, and management
# Reference: aws_backup_ports_generic_csv.csv

resource "aws_security_group" "backup_onprem" {
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "Backup-OnPrem"
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
  description       = "MCS/Avagent SSL between on-prem DD/Avamar"
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
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
  security_group_id = aws_security_group.backup_onprem.id
  description       = "MCS/Avagent SSL to on-prem DD/Avamar"
}

