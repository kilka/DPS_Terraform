# Security Group Ports CSV Generator

This script generates a CSV file from the CloudFormation security group template for easy documentation and review of all firewall rules.

## Files

- `generate-ports-csv.py` - Python script to generate the CSV
- `dps-security-groups.yaml` - CloudFormation template (source)
- `security-group-ports.csv` - Generated CSV output

## Usage

### Generate CSV

Run the script from the CloudFormation directory:

```bash
cd CloudFormation
python3 generate-ports-csv.py
```

Or make it executable and run directly:

```bash
chmod +x generate-ports-csv.py
./generate-ports-csv.py
```

### Output

The script will:
1. Parse `dps-security-groups.yaml`
2. Extract all security group ingress/egress rules
3. Generate `security-group-ports.csv`
4. Display summary statistics

## CSV Format

The generated CSV contains the following columns:

| Column | Description |
|--------|-------------|
| **Function** | Description of the rule (e.g., "SSH from on-prem") |
| **Source** | Source of the traffic (CIDR or security group) |
| **Destination** | Destination of the traffic (CIDR or security group) |
| **Protocol** | TCP, UDP, ICMP, or All |
| **Port** | Port number or range (e.g., "22" or "28001-28010") |

## Examples

### Viewing the CSV

```bash
# View in terminal
cat security-group-ports.csv | column -t -s,

# Open in spreadsheet application
open security-group-ports.csv
```

### Filtering Rules

```bash
# Find all SSH rules
grep "SSH" security-group-ports.csv

# Find all rules from on-prem Avamar
grep "OnPremAvamarCidr" security-group-ports.csv

# Find all rules to DDVE
grep ",Ddve," security-group-ports.csv
```

## When to Regenerate

Run the script whenever you modify the CloudFormation template to keep the CSV in sync:

1. After adding new security group rules
2. After modifying existing rules
3. After changing CIDR parameters
4. Before deploying changes (for documentation)

## Statistics

Current rule counts (as of last generation):

- **Total Rules:** 163
- **AVE Rules:** 63
- **DDVE Rules:** 46
- **External Services:** 54

## Notes

- The script handles CloudFormation intrinsic functions (`!Ref`)
- Rules are sorted by: Destination → Source → Port
- Port ranges are displayed as "start-end" (e.g., "28001-28010")
- Security group self-references show the SG name in both source and destination
