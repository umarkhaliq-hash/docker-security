FROM odoo:16.0

# Security: Run as non-root user
USER root

# Install security updates
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security

# Set secure permissions
RUN chown -R odoo:odoo /var/lib/odoo
RUN chown -R odoo:odoo /mnt/extra-addons

# Switch to non-root user
USER odoo

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8069/web/health || exit 1

EXPOSE 8069