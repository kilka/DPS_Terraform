# ============================================================================
# LAB SECURITY GROUP ARCHITECTURE
# ============================================================================
#
# This lab uses a least-privilege security group design:
#
# 1. Jump Host Security Groups:
#    - jump_host: Inbound RDP (3389) from authorized IP, Avamar client (28001-28002) from AVE, all outbound
#    - jump_to_backup: Egress rules for jump host to AVE/DDVE (management + backup client)
#
# 2. AVE Module Security Groups (configured when deploying AVE):
#    - AVE-specific SG: Created by AVE module with all AVE ports
#    - Pass these CIDR blocks to AVE module:
#      * allowed_ssh_cidr_blocks         = [public_subnet_cidr]  # SSH from jump host
#      * allowed_management_cidr_blocks  = [public_subnet_cidr]  # Management UIs from jump host
#      * allowed_data_cidr_blocks        = [public_subnet_cidr, private_subnet_cidr]  # Backups from jump + AVE↔DDVE
#
# 3. DDVE Module Security Groups (configured when deploying DDVE):
#    - DDVE-specific SG: Created by DDVE module with all DDVE ports
#    - Pass these CIDR blocks to DDVE module:
#      * allowed_ssh_cidr_blocks         = [public_subnet_cidr]  # SSH from jump host
#      * allowed_management_cidr_blocks  = [public_subnet_cidr]  # Management UIs from jump host
#      * allowed_data_cidr_blocks        = [private_subnet_cidr] # AVE↔DDVE replication
#
# Port Summary:
#   Jump → AVE (mgmt): 22, 443, 7543, 8543, 9443
#   Jump → AVE (backup outbound): 7778-7781, 28001-28002, 28810-28819, 30001-30003
#   AVE → Jump (backup inbound): 28001-28002 (avagent client activation and notification)
#   Jump → DDVE (mgmt): 22, 443, 3009
#   AVE ↔ DDVE (data): 2049 (NFS), 2051 (replication)
#
# ============================================================================

# Security group for Windows jump host
resource "aws_security_group" "jump_host" {
  name_prefix = "${var.lab_name}-jump-host-"
  description = "Security group for Windows jump host"
  vpc_id      = aws_vpc.lab.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-jump-host-sg"
      ManagedBy = "Terraform"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# RDP access from specified CIDR (or current public IP)
resource "aws_security_group_rule" "jump_host_rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [local.rdp_cidr]
  security_group_id = aws_security_group.jump_host.id
  description       = "RDP access from authorized IP"
}

# Avamar client inbound - AVE needs to connect TO the jump host for backups
# Port 28001: Avamar Administrator Server Port (client activation)
# Port 28002: Avamar avagent notification port (workorder notification from utility node)
resource "aws_security_group_rule" "jump_host_avamar_client" {
  type              = "ingress"
  from_port         = 28001
  to_port           = 28002
  protocol          = "tcp"
  cidr_blocks       = [var.private_subnet_cidr]
  security_group_id = aws_security_group.jump_host.id
  description       = "Avamar client agent (avagent) inbound from AVE"
}

# Allow outbound traffic for general internet access (Windows updates, downloads, etc.)
# Specific AVE/DDVE access is managed via the jump_to_backup security group
resource "aws_security_group_rule" "jump_host_internet_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jump_host.id
  description       = "Allow all outbound traffic for internet access"
}

# Note: The jump_to_backup security group has been removed because:
# 1. The jump_host security group already allows all outbound traffic (needed for internet access)
# 2. Having both created duplicate security group rules
# 3. The jump host SG's "allow all outbound" already covers access to AVE/DDVE
#
# The original design attempted to use separate SGs for least-privilege access,
# but in a lab environment with a Windows jump host that needs internet access,
# it's simpler to just allow all outbound from the jump host.
