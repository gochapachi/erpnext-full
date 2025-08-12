# Dockerfile - build a custom ERPNext image with common community apps fetched
FROM frappe/erpnext:latest

USER root
RUN apt-get update && apt-get install -y git jq && apt-get clean && rm -rf /var/lib/apt/lists/*

USER frappe
WORKDIR /home/frappe/frappe-bench

# Fetch commonly used community apps (non-fatal if any fail)
# Verified repos:
#  - https://github.com/frappe/hrms
#  - https://github.com/resilient-tech/india-compliance
#  - https://github.com/frappe/twilio-integration
RUN bench get-app hrms https://github.com/frappe/hrms || true \
 && bench get-app india_compliance https://github.com/resilient-tech/india-compliance || true \
 && bench get-app twilio_integration https://github.com/frappe/twilio-integration || true

# Don't auto-install apps at build time — site might not exist at build time.
# create-site service will install apps after DB/site ready.
