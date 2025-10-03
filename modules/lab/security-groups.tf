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

# Allow all outbound traffic from jump host
resource "aws_security_group_rule" "jump_host_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jump_host.id
  description       = "Allow all outbound traffic"
}

# Security group for internal lab resources (allows access from jump host)
resource "aws_security_group" "lab_internal" {
  name_prefix = "${var.lab_name}-internal-"
  description = "Security group for internal lab access from jump host"
  vpc_id      = aws_vpc.lab.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-internal-sg"
      ManagedBy = "Terraform"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Allow SSH from jump host to internal resources
resource "aws_security_group_rule" "internal_ssh_from_jump" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jump_host.id
  security_group_id        = aws_security_group.lab_internal.id
  description              = "SSH access from jump host"
}

# Allow HTTPS from jump host to internal resources (DDVE/AVE management)
resource "aws_security_group_rule" "internal_https_from_jump" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jump_host.id
  security_group_id        = aws_security_group.lab_internal.id
  description              = "HTTPS access from jump host for management UI"
}

# Allow all traffic within the internal security group (for DDVE/AVE communication)
resource "aws_security_group_rule" "internal_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.lab_internal.id
  description       = "Allow all traffic within lab internal security group"
}

# Allow all outbound traffic from internal resources
resource "aws_security_group_rule" "internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lab_internal.id
  description       = "Allow all outbound traffic"
}
