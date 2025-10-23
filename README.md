# Secure Odoo Docker Deployment

## Quick Start

1. **Build and run with security scanning:**
```bash
./security-scan.sh
```

2. **Start the application:**
```bash
docker-compose up -d
```

3. **Access Odoo:**
- URL: http://localhost:8069
- Database: odoo
- Username: admin (set during first login)

## Security Tools Included

### ✅ Trivy
- **Purpose**: Vulnerability scanning for container images and filesystem
- **Usage**: Automatically scans for CVEs, secrets, and misconfigurations
- **Reports**: `security-reports/odoo-vulnerabilities.json`

### ✅ Falco  
- **Purpose**: Runtime security monitoring
- **Usage**: Monitors container behavior for suspicious activities
- **Rules**: Custom rules in `falco-rules/custom-rules.yaml`

### ✅ Docker Bench Security
- **Purpose**: Docker host security assessment
- **Usage**: Checks Docker daemon and container configurations
- **Reports**: `security-reports/docker-bench-report.log`

## Security Features Implemented

- 🔒 Non-root user execution
- 🛡️ Capability dropping (CAP_DROP: ALL)
- 🚫 No new privileges
- 📁 Read-only root filesystem where possible
- 🌐 Network isolation
- 💓 Health checks
- 🔍 Runtime monitoring

## Commands

```bash
# Run security scan
./security-scan.sh

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# View Falco alerts
docker-compose logs falco
```

## Security Status

Your Odoo app **USES** these security tools:
- ✅ **Trivy**: Scans your Docker images for vulnerabilities
- ✅ **Falco**: Monitors runtime security in real-time  
- ✅ **Docker Bench**: Validates Docker security configuration

The security scan will show you exactly what vulnerabilities exist and how to fix them.