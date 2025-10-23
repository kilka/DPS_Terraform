# DDVE-specific security group
# NOTE: This security group contains all DDVE management and data ports per official documentation.
# Reference: Data Domain Virtual Edition Best Practices Guide - Inbound/Outbound Ports

resource "aws_security_group" "ddve" {
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "DDVE"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# INBOUND RULES (from Data Domain Virtual Edition Best Practices Guide)
# ============================================================================

# SSH access (TCP 22) - Used for SSH (CLI) access and configuration
resource "aws_security_group_rule" "ssh" {
  count             = length(var.allowed_ssh_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidr_blocks
  security_group_id = aws_security_group.ddve.id
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
  security_group_id = aws_security_group.ddve.id
  description       = "SSH access from backup data networks (AVE to DDVE)"
}

# HTTPS access (TCP 443) - Used for DDSM (GUI) access and configuration
resource "aws_security_group_rule" "https" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "HTTPS access for DDSM GUI and configuration"
}

# RPC (TCP 111) - RPC portmapper for NFS
resource "aws_security_group_rule" "rpc_tcp" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "RPC portmapper for NFS (TCP)"
}

# RPC (UDP 111) - RPC portmapper for NFS
resource "aws_security_group_rule" "rpc_udp" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 111
  to_port           = 111
  protocol          = "udp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "RPC portmapper for NFS (UDP)"
}

# NFS/DD Boost (TCP 2049) - Main port used by NFS and DD Boost
resource "aws_security_group_rule" "nfs_tcp" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "NFS and DD Boost data transfer (TCP)"
}

# NFS/DD Boost (UDP 2049) - Main port used by NFS and DD Boost
resource "aws_security_group_rule" "nfs_udp" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "udp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "NFS and DD Boost data transfer (UDP)"
}

# Replication/DD Boost/Optimized Duplication (TCP 2051)
resource "aws_security_group_rule" "replication_2051" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2051
  to_port           = 2051
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "Replication, DD Boost, and Optimized Duplication"
}

# Data Domain replication (TCP 2052) - DD replication from AVE
resource "aws_security_group_rule" "replication_2052" {
  count             = length(var.allowed_data_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2052
  to_port           = 2052
  protocol          = "tcp"
  cidr_blocks       = var.allowed_data_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "Data Domain replication from AVE"
}

# SNMP (TCP 161) - Used for SNMP monitoring
resource "aws_security_group_rule" "snmp_tcp" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ddve.id
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
  security_group_id = aws_security_group.ddve.id
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
  security_group_id = aws_security_group.ddve.id
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
  security_group_id = aws_security_group.ddve.id
  description       = "SNMP traps (UDP)"
}

# System Management Service (TCP 3009) - Used for remote management via DDSM
resource "aws_security_group_rule" "sms" {
  count             = length(var.allowed_management_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 3009
  to_port           = 3009
  protocol          = "tcp"
  cidr_blocks       = var.allowed_management_cidr_blocks
  security_group_id = aws_security_group.ddve.id
  description       = "System Management Service (SMS) for remote DDSM management"
}

# ============================================================================
# OUTBOUND RULES (from Data Domain Virtual Edition Best Practices Guide)
# ============================================================================

# NTP (UDP 123) - Time synchronization
resource "aws_security_group_rule" "ntp_outbound" {
  type              = "egress"
  from_port         = 123
  to_port           = 123
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "NTP time synchronization"
}

# HTTPS (TCP 443) - Communication with outside services and S3
resource "aws_security_group_rule" "https_outbound" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "HTTPS for AWS services, S3, and external communication"
}

# NFS/DD Boost (TCP 2049) - Outbound NFS traffic
resource "aws_security_group_rule" "nfs_outbound" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound NFS and DD Boost"
}

# Replication/DD Boost/Optimized Duplication (TCP 2051) - Outbound replication
resource "aws_security_group_rule" "replication_outbound" {
  type              = "egress"
  from_port         = 2051
  to_port           = 2051
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound Replication, DD Boost, and Optimized Duplication"
}

# SNMP (TCP 161) - Outbound SNMP
resource "aws_security_group_rule" "snmp_tcp_outbound" {
  type              = "egress"
  from_port         = 161
  to_port           = 161
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound SNMP (TCP)"
}

# SNMP (UDP 161) - Outbound SNMP
resource "aws_security_group_rule" "snmp_udp_outbound" {
  type              = "egress"
  from_port         = 161
  to_port           = 161
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound SNMP (UDP)"
}

# SNMP Traps (TCP 163) - Outbound SNMP traps
resource "aws_security_group_rule" "snmp_trap_tcp_outbound" {
  type              = "egress"
  from_port         = 163
  to_port           = 163
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound SNMP traps (TCP)"
}

# SNMP Traps (UDP 163) - Outbound SNMP traps
resource "aws_security_group_rule" "snmp_trap_udp_outbound" {
  type              = "egress"
  from_port         = 163
  to_port           = 163
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound SNMP traps (UDP)"
}

# System Management Service (TCP 3009) - Outbound SMS traffic
resource "aws_security_group_rule" "sms_outbound" {
  type              = "egress"
  from_port         = 3009
  to_port           = 3009
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "Outbound System Management Service (SMS)"
}

# DNS (UDP 53) - DNS resolution
resource "aws_security_group_rule" "dns_udp_outbound" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "DNS resolution (UDP)"
}

# DNS (TCP 53) - DNS resolution
resource "aws_security_group_rule" "dns_tcp_outbound" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "DNS resolution (TCP)"
}

# HTTP (TCP 80) - Package updates and AWS metadata service
resource "aws_security_group_rule" "http_outbound" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ddve.id
  description       = "HTTP for package updates and AWS metadata service"
}
