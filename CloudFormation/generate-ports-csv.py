#!/usr/bin/env python3
"""
Generate a CSV file from CloudFormation security group YAML template.

This script parses the dps-security-groups.yaml CloudFormation template
and extracts all security group ingress and egress rules into a CSV format
for easier viewing and documentation.

Usage:
    python3 generate-ports-csv.py

Output:
    security-group-ports.csv
"""

import re
import csv
import sys
from pathlib import Path


def parse_security_group_yaml(yaml_file):
    """
    Parse CloudFormation YAML file and extract security group rules.

    Args:
        yaml_file (str): Path to the YAML file

    Returns:
        list: List of dictionaries containing rule information
    """
    with open(yaml_file, 'r') as f:
        content = f.read()

    csv_data = []
    current_rule = {}
    in_ingress = False
    in_egress = False

    lines = content.split('\n')
    for i, line in enumerate(lines):
        # Detect ingress/egress rules
        if 'Type: AWS::EC2::SecurityGroupIngress' in line:
            in_ingress = True
            in_egress = False
            current_rule = {'direction': 'ingress'}
        elif 'Type: AWS::EC2::SecurityGroupEgress' in line:
            in_egress = True
            in_ingress = False
            current_rule = {'direction': 'egress'}

        # Extract security group
        if 'GroupId: !Ref' in line:
            match = re.search(r'GroupId: !Ref (\w+)', line)
            if match:
                current_rule['group'] = match.group(1).replace('SecurityGroup', '')

        # Extract protocol
        if 'IpProtocol:' in line:
            match = re.search(r'IpProtocol:\s*(\w+)', line)
            if match:
                protocol = match.group(1)
                protocol_map = {'tcp': 'TCP', 'udp': 'UDP', 'icmp': 'ICMP', '-1': 'All'}
                current_rule['protocol'] = protocol_map.get(protocol, protocol.upper())

        # Extract ports
        if 'FromPort:' in line:
            match = re.search(r'FromPort:\s*(-?\d+)', line)
            if match:
                current_rule['from_port'] = match.group(1)
        if 'ToPort:' in line:
            match = re.search(r'ToPort:\s*(-?\d+)', line)
            if match:
                current_rule['to_port'] = match.group(1)

        # Extract CIDR
        if 'CidrIp: !Ref' in line:
            match = re.search(r'CidrIp: !Ref (\w+)', line)
            if match:
                current_rule['cidr'] = match.group(1)
        elif 'CidrIp:' in line and '!Ref' not in line:
            match = re.search(r"CidrIp:\s*['\"]?([\d\./]+)['\"]?", line)
            if match:
                current_rule['cidr'] = match.group(1)

        # Extract source/destination security group
        if 'SourceSecurityGroupId: !Ref' in line:
            match = re.search(r'SourceSecurityGroupId: !Ref (\w+)', line)
            if match:
                current_rule['source_sg'] = match.group(1).replace('SecurityGroup', '')
        if 'DestinationSecurityGroupId: !Ref' in line:
            match = re.search(r'DestinationSecurityGroupId: !Ref (\w+)', line)
            if match:
                current_rule['dest_sg'] = match.group(1).replace('SecurityGroup', '')

        # Extract description
        if 'Description:' in line and (in_ingress or in_egress):
            match = re.search(r'Description:\s*(.+)', line)
            if match:
                current_rule['description'] = match.group(1).strip()

                # Rule is complete, add to data
                if 'group' in current_rule and 'protocol' in current_rule:
                    # Determine source and destination
                    if current_rule['direction'] == 'ingress':
                        source = current_rule.get('cidr') or current_rule.get('source_sg', 'Unknown')
                        destination = current_rule['group']
                    else:  # egress
                        source = current_rule['group']
                        destination = current_rule.get('cidr') or current_rule.get('dest_sg', 'Unknown')

                    # Format port
                    from_port = current_rule.get('from_port', '')
                    to_port = current_rule.get('to_port', '')
                    if from_port == to_port:
                        port = str(from_port)
                    elif from_port and to_port:
                        port = f"{from_port}-{to_port}"
                    else:
                        port = ''

                    csv_data.append({
                        'Function': current_rule.get('description', ''),
                        'Source': source,
                        'Destination': destination,
                        'Protocol': current_rule.get('protocol', ''),
                        'Port': port
                    })

                # Reset for next rule
                in_ingress = False
                in_egress = False
                current_rule = {}

    return csv_data


def write_csv(data, output_file):
    """
    Write security group rules to CSV file.

    Args:
        data (list): List of rule dictionaries
        output_file (str): Path to output CSV file
    """
    # Sort by destination, source, port
    data.sort(key=lambda x: (x['Destination'], x['Source'], x.get('Port', '')))

    # Write to CSV
    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['Function', 'Source', 'Destination', 'Protocol', 'Port']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for row in data:
            writer.writerow(row)


def print_summary(data, output_file):
    """
    Print summary statistics and preview of the CSV data.

    Args:
        data (list): List of rule dictionaries
        output_file (str): Path to output CSV file
    """
    print(f"\n{'='*80}")
    print(f"Security Group Ports CSV Generator")
    print(f"{'='*80}")
    print(f"\n✅ Successfully generated: {output_file}")
    print(f"📊 Total rules: {len(data)}")

    # Count by destination
    dest_counts = {}
    for row in data:
        dest = row['Destination']
        dest_counts[dest] = dest_counts.get(dest, 0) + 1

    print(f"\n📋 Rules by destination:")
    for dest, count in sorted(dest_counts.items()):
        print(f"   {dest}: {count} rules")

    # Show preview
    print(f"\n📄 Preview (first 10 rows):")
    print(f"{'-'*120}")
    print(f"{'Function':<50} {'Source':<25} {'Destination':<15} {'Protocol':<10} {'Port':<10}")
    print(f"{'-'*120}")
    for i, row in enumerate(data[:10]):
        print(f"{row['Function']:<50} {row['Source']:<25} {row['Destination']:<15} {row['Protocol']:<10} {row['Port']:<10}")

    if len(data) > 10:
        print(f"\n... and {len(data) - 10} more rows")

    print(f"\n{'='*80}\n")


def main():
    """Main execution function."""
    # File paths
    script_dir = Path(__file__).parent
    yaml_file = script_dir / 'dps-security-groups.yaml'
    output_file = script_dir / 'security-group-ports.csv'

    # Check if YAML file exists
    if not yaml_file.exists():
        print(f"❌ Error: Could not find {yaml_file}")
        print(f"   Make sure you run this script from the CloudFormation directory.")
        sys.exit(1)

    try:
        # Parse YAML and extract rules
        print(f"📖 Reading: {yaml_file}")
        data = parse_security_group_yaml(yaml_file)

        # Write CSV
        print(f"✍️  Writing: {output_file}")
        write_csv(data, output_file)

        # Print summary
        print_summary(data, output_file)

    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
