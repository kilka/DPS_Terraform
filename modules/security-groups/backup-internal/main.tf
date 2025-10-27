# Backup Internal Security Group - Self-Referencing Rules
# This security group handles communication between backup devices (AVE/DDVE instances)
# All rules are self-referencing - allowing instances in this SG to communicate with each other
# Reference: aws_backup_ports_generic_csv.csv

resource "aws_security_group" "backup_internal" {
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "Backup-Internal"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
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
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Echo/Registration between backup devices"
}

resource "aws_security_group_rule" "self_echo_tcp_egress" {
  type                     = "egress"
  from_port                = 7
  to_port                  = 7
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Echo/Registration between backup devices"
}

# SSH (TCP 22) - SSH between backup devices
resource "aws_security_group_rule" "self_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SSH between backup devices"
}

resource "aws_security_group_rule" "self_ssh_egress" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SSH between backup devices"
}

# RPC Portmapper (TCP 111) - RPC Portmapper TCP between backup devices
resource "aws_security_group_rule" "self_rpc_tcp_ingress" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "RPC Portmapper TCP between backup devices"
}

resource "aws_security_group_rule" "self_rpc_tcp_egress" {
  type                     = "egress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "RPC Portmapper TCP between backup devices"
}

# RPC Portmapper (UDP 111) - RPC Portmapper UDP between backup devices
resource "aws_security_group_rule" "self_rpc_udp_ingress" {
  type                     = "ingress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "RPC Portmapper UDP between backup devices"
}

resource "aws_security_group_rule" "self_rpc_udp_egress" {
  type                     = "egress"
  from_port                = 111
  to_port                  = 111
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "RPC Portmapper UDP between backup devices"
}

# HTTPS (TCP 443) - HTTPS between backup devices
resource "aws_security_group_rule" "self_https_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "HTTPS between backup devices"
}

resource "aws_security_group_rule" "self_https_egress" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "HTTPS between backup devices"
}

# Admin service (TCP 700) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_700_ingress" {
  type                     = "ingress"
  from_port                = 700
  to_port                  = 700
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_700_egress" {
  type                     = "egress"
  from_port                = 700
  to_port                  = 700
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

# NFS (TCP 2049) - NFS TCP between backup devices
resource "aws_security_group_rule" "self_nfs_tcp_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS TCP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_tcp_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS TCP between backup devices"
}

# NFS (UDP 2049) - NFS UDP between backup devices
resource "aws_security_group_rule" "self_nfs_udp_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS UDP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_udp_egress" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS UDP between backup devices"
}

# DD Replication (TCP 2051) - DD Replication between backup devices
resource "aws_security_group_rule" "self_dd_repl_ingress" {
  type                     = "ingress"
  from_port                = 2051
  to_port                  = 2051
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "DD Replication between backup devices"
}

resource "aws_security_group_rule" "self_dd_repl_egress" {
  type                     = "egress"
  from_port                = 2051
  to_port                  = 2051
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "DD Replication between backup devices"
}

# NFS mountd (TCP 2052) - NFS mountd TCP between backup devices
resource "aws_security_group_rule" "self_nfs_mountd_tcp_ingress" {
  type                     = "ingress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS mountd TCP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_mountd_tcp_egress" {
  type                     = "egress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS mountd TCP between backup devices"
}

# NFS mountd (UDP 2052) - NFS mountd UDP between backup devices
resource "aws_security_group_rule" "self_nfs_mountd_udp_ingress" {
  type                     = "ingress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS mountd UDP between backup devices"
}

resource "aws_security_group_rule" "self_nfs_mountd_udp_egress" {
  type                     = "egress"
  from_port                = 2052
  to_port                  = 2052
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "NFS mountd UDP between backup devices"
}

# Archive tier (TCP 3008) - Archive tier between backup devices (optional)
resource "aws_security_group_rule" "self_archive_tier_ingress" {
  type                     = "ingress"
  from_port                = 3008
  to_port                  = 3008
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Archive tier between backup devices (optional)"
}

resource "aws_security_group_rule" "self_archive_tier_egress" {
  type                     = "egress"
  from_port                = 3008
  to_port                  = 3008
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Archive tier between backup devices (optional)"
}

# SMS/System management (TCP 3009) - SMS/System management between backup devices
resource "aws_security_group_rule" "self_sms_ingress" {
  type                     = "ingress"
  from_port                = 3009
  to_port                  = 3009
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SMS/System management between backup devices"
}

resource "aws_security_group_rule" "self_sms_egress" {
  type                     = "egress"
  from_port                = 3009
  to_port                  = 3009
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SMS/System management between backup devices"
}

# Update Manager/Installation Manager (TCP 7543) - Update Manager/Installation Manager between backup devices
resource "aws_security_group_rule" "self_update_mgr_ingress" {
  type                     = "ingress"
  from_port                = 7543
  to_port                  = 7543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Update Manager/Installation Manager between backup devices"
}

resource "aws_security_group_rule" "self_update_mgr_egress" {
  type                     = "egress"
  from_port                = 7543
  to_port                  = 7543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Update Manager/Installation Manager between backup devices"
}

# Admin services (TCP 7778-7781) - Admin services between backup devices
resource "aws_security_group_rule" "self_admin_7778_ingress" {
  type                     = "ingress"
  from_port                = 7778
  to_port                  = 7781
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin services between backup devices"
}

resource "aws_security_group_rule" "self_admin_7778_egress" {
  type                     = "egress"
  from_port                = 7778
  to_port                  = 7781
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin services between backup devices"
}

# Admin service (TCP 8443) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "self_admin_8443_ingress" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

resource "aws_security_group_rule" "self_admin_8443_egress" {
  type                     = "egress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

# Admin service (TCP 8543) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_8543_ingress" {
  type                     = "ingress"
  from_port                = 8543
  to_port                  = 8543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_8543_egress" {
  type                     = "egress"
  from_port                = 8543
  to_port                  = 8543
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

# App/Service (TCP 8888) - App/Service to management tools (vCenter/BRM)
resource "aws_security_group_rule" "self_app_8888_ingress" {
  type                     = "ingress"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

resource "aws_security_group_rule" "self_app_8888_egress" {
  type                     = "egress"
  from_port                = 8888
  to_port                  = 8888
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "App/Service between backup devices (vCenter/BRM)"
}

# Admin service (TCP 9090) - Admin service between backup devices
resource "aws_security_group_rule" "self_admin_9090_ingress" {
  type                     = "ingress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

resource "aws_security_group_rule" "self_admin_9090_egress" {
  type                     = "egress"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Admin service between backup devices"
}

# AUI/Replication (TCP 9443) - AUI/Replication between backup devices
resource "aws_security_group_rule" "self_aui_repl_ingress" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "AUI/Replication between backup devices"
}

resource "aws_security_group_rule" "self_aui_repl_egress" {
  type                     = "egress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "AUI/Replication between backup devices"
}

# SNMP (TCP 161-163) - SNMP TCP between backup devices
resource "aws_security_group_rule" "self_snmp_tcp_ingress" {
  type                     = "ingress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SNMP TCP between backup devices"
}

resource "aws_security_group_rule" "self_snmp_tcp_egress" {
  type                     = "egress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SNMP TCP between backup devices"
}

# SNMP (UDP 161-163) - SNMP UDP between backup devices
resource "aws_security_group_rule" "self_snmp_udp_ingress" {
  type                     = "ingress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SNMP UDP between backup devices"
}

resource "aws_security_group_rule" "self_snmp_udp_egress" {
  type                     = "egress"
  from_port                = 161
  to_port                  = 163
  protocol                 = "udp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SNMP UDP between backup devices"
}

# Legacy connections (TCP 27000) - Legacy connections between backup devices
resource "aws_security_group_rule" "self_legacy_ingress" {
  type                     = "ingress"
  from_port                = 27000
  to_port                  = 27000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Legacy connections between backup devices"
}

resource "aws_security_group_rule" "self_legacy_egress" {
  type                     = "egress"
  from_port                = 27000
  to_port                  = 27000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Legacy connections between backup devices"
}

# MCS replication (TCP 28001-28010) - MCS replication between backup devices
resource "aws_security_group_rule" "self_mcs_repl_ingress" {
  type                     = "ingress"
  from_port                = 28001
  to_port                  = 28010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "MCS replication between backup devices"
}

resource "aws_security_group_rule" "self_mcs_repl_egress" {
  type                     = "egress"
  from_port                = 28001
  to_port                  = 28010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "MCS replication between backup devices"
}

# Internal agents (TCP 28810-28819) - Internal agents between backup devices
resource "aws_security_group_rule" "self_internal_agents_ingress" {
  type                     = "ingress"
  from_port                = 28810
  to_port                  = 28819
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Internal agents between backup devices"
}

resource "aws_security_group_rule" "self_internal_agents_egress" {
  type                     = "egress"
  from_port                = 28810
  to_port                  = 28819
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "Internal agents between backup devices"
}

# SSL data path (TCP 29000) - SSL data path between backup devices
resource "aws_security_group_rule" "self_ssl_data_ingress" {
  type                     = "ingress"
  from_port                = 29000
  to_port                  = 29000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SSL data path between backup devices"
}

resource "aws_security_group_rule" "self_ssl_data_egress" {
  type                     = "egress"
  from_port                = 29000
  to_port                  = 29000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "SSL data path between backup devices"
}

# MCS/Avagent SSL (TCP 30001-30010) - MCS/Avagent SSL between backup devices
resource "aws_security_group_rule" "self_mcs_avagent_ssl_ingress" {
  type                     = "ingress"
  from_port                = 30001
  to_port                  = 30010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "MCS/Avagent SSL between backup devices"
}

resource "aws_security_group_rule" "self_mcs_avagent_ssl_egress" {
  type                     = "egress"
  from_port                = 30001
  to_port                  = 30010
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backup_internal.id
  security_group_id        = aws_security_group.backup_internal.id
  description              = "MCS/Avagent SSL between backup devices"
}
