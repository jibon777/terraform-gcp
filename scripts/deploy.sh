#!/bin/bash
set -e

echo "🚀 Starting Terraform Deployment..."

# Initialize Terraform
terraform init -reconfigure

# Validate Terraform files
terraform validate

# Plan deployment
terraform plan -var="project_id=dev-aji" -var="max_instances=5"

# Apply changes (auto-approve untuk CI/CD)
terraform apply -auto-approve -var="project_id=dev-aji" -var="max_instances=5"

echo "✅ Deployment completed successfully!"