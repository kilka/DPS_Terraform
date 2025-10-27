# Backup Management Security Group
# This security group handles management access, monitoring, and external services
# Includes: Management host access, DPA monitoring, NTP/DNS/SMTP/Dell ESRS
# Reference: aws_backup_ports_generic_csv.csv

resource "aws_security_group" "backup_management" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
      Component = "Backup-Management"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
  description       = "DPA Rest API"
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
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
  security_group_id = aws_security_group.backup_management.id
  description       = "Dell ESRS"
}

# HTTPS egress for S3 VPC endpoint and AWS services
resource "aws_security_group_rule" "to_s3_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backup_management.id
  description       = "HTTPS egress for S3 VPC endpoint and AWS services"
}
