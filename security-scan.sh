#!/bin/bash

echo "Starting Docker Security Assessment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create results directory
mkdir -p security-reports

echo -e "${YELLOW}Step 1: Installing Security Tools...${NC}"

# Install Trivy
if ! command -v trivy &> /dev/null; then
    echo "Installing Trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

# Install Docker Bench Security
if [ ! -d "docker-bench-security" ]; then
    echo "Cloning Docker Bench Security..."
    git clone https://github.com/docker/docker-bench-security.git
fi

echo -e "${YELLOW}Step 2: Building Docker Images...${NC}"
docker-compose build

echo -e "${YELLOW}Step 3: Trivy Vulnerability Scanning...${NC}"

# Scan Odoo image
echo "Scanning Odoo image for vulnerabilities..."
trivy image --format json --output security-reports/odoo-vulnerabilities.json docker-security_odoo:latest
trivy image --severity HIGH,CRITICAL docker-security_odoo:latest

# Scan PostgreSQL image
echo "Scanning PostgreSQL image for vulnerabilities..."
trivy image --format json --output security-reports/postgres-vulnerabilities.json postgres:13-alpine
trivy image --severity HIGH,CRITICAL postgres:13-alpine

# Scan for secrets
echo "Scanning for secrets in filesystem..."
trivy fs --format json --output security-reports/secrets-scan.json .

echo -e "${YELLOW}Step 4: Docker Bench Security Assessment...${NC}"
cd docker-bench-security
sudo ./docker-bench-security.sh -l security-reports/docker-bench-report.log
cd ..

echo -e "${YELLOW}Step 5: Generating Security Report...${NC}"

cat > security-reports/security-summary.md << EOF
# Docker Security Assessment Report

## Vulnerability Scan Results
- Odoo Image: See \`odoo-vulnerabilities.json\`
- PostgreSQL Image: See \`postgres-vulnerabilities.json\`
- Secrets Scan: See \`secrets-scan.json\`

## Docker Bench Security
- Full Report: See \`docker-bench-report.log\`

## Security Measures Implemented
  Non-root user in containers
  Read-only root filesystem where possible
  Dropped unnecessary capabilities
  No new privileges security option
  Network isolation
  Health checks
  Runtime security monitoring with Falco

## Recommendations
1. Regularly update base images
2. Monitor Falco alerts for runtime threats
3. Review and fix HIGH/CRITICAL vulnerabilities
4. Implement secrets management (e.g., Docker Secrets)
5. Enable container image signing

Generated on: $(date)
EOF

echo -e "${GREEN} Security assessment complete!${NC}"
echo -e "${GREEN} Reports saved in: security-reports/${NC}"
echo -e "${YELLOW} View summary: cat security-reports/security-summary.md${NC}"