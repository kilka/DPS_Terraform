# AVE-specific security group
# NOTE: This security group contains all AVE management, backup, and data ports per official documentation.
# Reference: Dell Avamar Virtual Edition Installation and Upgrade Guide - Security Group Settings

resource "aws_security_group" "ave" {
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "AVE"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# INBOUND RULES (from Dell Avamar Virtual Edition Installation Guide)
# ============================================================================

# ICMP - Allow all ICMP traffic (includes Time Exceeded, Destination Unreachable, Echo Reply, etc.)
resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "ICMP (all types)"
}

# SSH access (TCP 22) - Used for SSH (CLI) access and configuration
resource "aws_security_group_rule" "ssh" {
  count             = length(var.allowed_ssh_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "SSH access for CLI configuration"
}

# SSH access from backup data networks (TCP 22) - Used for AVE to DDVE SSH communication
# Only creates rules for CIDR blocks not already in allowed_ssh_cidr_blocks to avoid duplicates
resource "aws_security_group_rule" "ssh_data" {
  count             = length(setsubtract(var.allowed_data_cidr_blocks, var.allowed_ssh_cidr_blocks)) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = setsubtract(var.allowed_data_cidr_blocks, var.allowed_ssh_cidr_blocks)
  security_group_id = aws_security_group.ave.id
  description       = "SSH access from backup data networks (AVE to DDVE)"
}

# HTTPS access (TCP 443) - Used for web UI access and configuration
resource "aws_security_group_rule" "https" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "HTTPS access for web UI and configuration"
}

# SNMP (TCP 161) - Used for SNMP monitoring
resource "aws_security_group_rule" "snmp_tcp" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "SNMP monitoring (TCP)"
}

# SNMP (UDP 161) - Used for SNMP monitoring
resource "aws_security_group_rule" "snmp_udp" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "SNMP monitoring (UDP)"
}

# SNMP Traps (TCP 163) - Used for SNMP traps
resource "aws_security_group_rule" "snmp_trap_tcp" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 163
  to_port           = 163
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "SNMP traps (TCP)"
}

# SNMP Traps (UDP 163) - Used for SNMP traps
resource "aws_security_group_rule" "snmp_trap_udp" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 163
  to_port           = 163
  protocol          = "udp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "SNMP traps (UDP)"
}

# Avamar Server (TCP 700) - Core Avamar service port
resource "aws_security_group_rule" "avamar_server" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 700
  to_port           = 700
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Avamar Server service"
}

# Avamar Administrator (TCP 7543) - Avamar Administrator UI
resource "aws_security_group_rule" "avamar_admin" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7543
  to_port           = 7543
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Avamar Administrator UI"
}

# Backup client communication (TCP 7778-7781) - Client backup communication
resource "aws_security_group_rule" "backup_client" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 7778
  to_port           = 7781
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Backup client communication"
}

# Avamar Web UI (TCP 8543) - Web UI service
resource "aws_security_group_rule" "web_ui" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 8543
  to_port           = 8543
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Avamar Web UI service"
}

# Avamar Data Store (TCP 9090) - Data store service
resource "aws_security_group_rule" "data_store" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Avamar Data Store service"
}

# Enterprise Manager (TCP 9443) - Enterprise Manager UI
resource "aws_security_group_rule" "enterprise_manager" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Enterprise Manager UI"
}

# License service (TCP 27000) - License management
resource "aws_security_group_rule" "license" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 27000
  to_port           = 27000
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "License management service"
}

# HFS ports (TCP 28001-28002) - HFS communication
resource "aws_security_group_rule" "hfs" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 28001
  to_port           = 28002
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "HFS communication"
}

# MCS ports (TCP 28810-28819) - MCS communication
resource "aws_security_group_rule" "mcs" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 28810
  to_port           = 28819
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "MCS communication"
}

# Replication service (TCP 29000) - Replication
resource "aws_security_group_rule" "replication" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 29000
  to_port           = 29000
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "Replication service"
}

# DD Boost/Replication (TCP 2051) - DD Boost and replication from DDVE
resource "aws_security_group_rule" "dd_boost_replication" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2051
  to_port           = 2051
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "DD Boost and replication from DDVE"
}

# GSAN ports (TCP 30001-30010) - GSAN communication
resource "aws_security_group_rule" "gsan" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 30001
  to_port           = 30010
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ave.id
  description       = "GSAN communication"
}

# ============================================================================
# OUTBOUND RULES (from Dell Avamar Virtual Edition Installation Guide)
# ============================================================================

# ICMP - Allow all ICMP traffic (outbound)
resource "aws_security_group_rule" "icmp_outbound" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "ICMP (all types, outbound)"
}

# Echo service (TCP 7) - Echo protocol
resource "aws_security_group_rule" "echo_outbound" {
  type              = "egress"
  from_port         = 7
  to_port           = 7
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Echo protocol"
}

# SSH (TCP 22) - Outbound SSH
resource "aws_security_group_rule" "ssh_outbound" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound SSH"
}

# SMTP (TCP 25) - Email notifications
resource "aws_security_group_rule" "smtp_outbound" {
  type              = "egress"
  from_port         = 25
  to_port           = 25
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "SMTP for email notifications"
}

# DNS (UDP 53) - DNS resolution
resource "aws_security_group_rule" "dns_udp_outbound" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "DNS resolution (UDP)"
}

# HTTP (TCP 80) - Package updates and AWS metadata
resource "aws_security_group_rule" "http_outbound" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "HTTP for package updates and AWS metadata"
}

# RPC (TCP 111) - RPC services
resource "aws_security_group_rule" "rpc_tcp_outbound" {
  type              = "egress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "RPC services (TCP)"
}

# RPC (UDP 111) - RPC services
resource "aws_security_group_rule" "rpc_udp_outbound" {
  type              = "egress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "RPC services (UDP)"
}

# SNMP (TCP 161) - Outbound SNMP
resource "aws_security_group_rule" "snmp_tcp_outbound" {
  type              = "egress"
  from_port         = 161
  to_port           = 161
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound SNMP (TCP)"
}

# SNMP (UDP 161) - Outbound SNMP
resource "aws_security_group_rule" "snmp_udp_outbound" {
  type              = "egress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound SNMP (UDP)"
}

# SNMP Traps (TCP 163) - Outbound SNMP traps
resource "aws_security_group_rule" "snmp_trap_tcp_outbound" {
  type              = "egress"
  from_port         = 163
  to_port           = 163
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound SNMP traps (TCP)"
}

# SNMP Traps (UDP 163) - Outbound SNMP traps
resource "aws_security_group_rule" "snmp_trap_udp_outbound" {
  type              = "egress"
  from_port         = 163
  to_port           = 163
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound SNMP traps (UDP)"
}

# HTTPS (TCP 443) - Communication with outside services
resource "aws_security_group_rule" "https_outbound" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "HTTPS for AWS services and external communication"
}

# Avamar Server (TCP 700) - Outbound Avamar service
resource "aws_security_group_rule" "avamar_server_outbound" {
  type              = "egress"
  from_port         = 700
  to_port           = 700
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound Avamar Server service"
}

# NFS (TCP 2049) - Outbound NFS traffic
resource "aws_security_group_rule" "nfs_tcp_outbound" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound NFS (TCP)"
}

# NFS (UDP 2049) - Outbound NFS traffic
resource "aws_security_group_rule" "nfs_udp_outbound" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound NFS (UDP)"
}

# Data Domain replication (TCP 2052) - DD replication
resource "aws_security_group_rule" "dd_replication_tcp_outbound" {
  type              = "egress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Data Domain replication (TCP)"
}

# Data Domain replication (UDP 2052) - DD replication
resource "aws_security_group_rule" "dd_replication_udp_outbound" {
  type              = "egress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Data Domain replication (UDP)"
}

# MCS (TCP 3008) - Outbound MCS
resource "aws_security_group_rule" "mcs_outbound" {
  type              = "egress"
  from_port         = 3008
  to_port           = 3008
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound MCS"
}

# Web services (TCP 8443) - Outbound web services
resource "aws_security_group_rule" "web_services_outbound" {
  type              = "egress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound web services"
}

# Replication (TCP 8888) - Outbound replication
resource "aws_security_group_rule" "replication_8888_outbound" {
  type              = "egress"
  from_port         = 8888
  to_port           = 8888
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound replication"
}

# Enterprise Manager (TCP 9443) - Outbound Enterprise Manager
resource "aws_security_group_rule" "enterprise_manager_outbound" {
  type              = "egress"
  from_port         = 9443
  to_port           = 9443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound Enterprise Manager"
}

# License service (TCP 27000) - Outbound license
resource "aws_security_group_rule" "license_outbound" {
  type              = "egress"
  from_port         = 27000
  to_port           = 27000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound license service"
}

# HFS ports (TCP 28001-28010) - Outbound HFS
resource "aws_security_group_rule" "hfs_outbound" {
  type              = "egress"
  from_port         = 28001
  to_port           = 28010
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound HFS communication"
}

# Replication service (TCP 29000) - Outbound replication
resource "aws_security_group_rule" "replication_outbound" {
  type              = "egress"
  from_port         = 29000
  to_port           = 29000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound replication service"
}

# GSAN ports (TCP 30001-30010) - Outbound GSAN
resource "aws_security_group_rule" "gsan_outbound" {
  type              = "egress"
  from_port         = 30001
  to_port           = 30010
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ave.id
  description       = "Outbound GSAN communication"
}
