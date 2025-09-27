# Terraform GitHub Actions Workflows

This repository contains GitHub Actions workflows for managing Terraform
infrastructure with proper validation, security, and deployment practices.

## Workflow Overview

### 1. Validation (`terraform-validate.yml`) **Triggers:** Pull requests with
Terraform file changes **Purpose:** Ensure code quality and syntax correctness

**What it does:**
- Checks Terraform formatting with `terraform fmt`
- Validates syntax with `terraform validate`
- Runs TFLint for best practices and error detection

**Why:** Catches basic errors early, enforces consistent formatting, and
prevents broken configurations from being merged.

### 2. Planning (`terraform-plan.yml`) **Triggers:** Pull requests with
Terraform file changes **Purpose:** Preview infrastructure changes and estimate
costs

**What it does:**
- Generates execution plan with `terraform plan`
- Posts plan output as PR comment for review
- Estimates cost changes with Infracost

**Why:** Allows teams to review infrastructure changes before deployment and
understand financial impact.

### 3. Security (`terraform-security.yml`) **Triggers:** Pull requests with
Terraform file changes **Purpose:** Identify security misconfigurations and
vulnerabilities

**What it does:**
- Scans with Checkov for security best practices
- Runs TFSec for AWS security issues
- Performs Terrascan policy validation
- Uploads results to GitHub Security tab

**Why:** Prevents security vulnerabilities from being deployed to production
infrastructure.

### 4. Deployment (`terraform-deploy.yml`) **Triggers:** Pushes to main branch
with Terraform file changes **Purpose:** Apply approved infrastructure changes

**What it does:**
- Runs final plan before deployment
- Applies changes with `terraform apply`
- Posts deployment status as commit comment
- Requires manual approval via environment protection

**Why:** Safely deploys infrastructure changes after all validations pass.

### 5. Documentation (`terraform-docs.yml`) **Triggers:** Pull requests with
Terraform file changes **Purpose:** Keep documentation current with code changes

**What it does:**
- Generates module documentation with terraform-docs
- Updates README.md automatically
- Commits documentation changes back to PR

**Why:** Ensures documentation stays synchronized with infrastructure code
changes.

## Setup Requirements

1. **Environment Protection:** Configure production environment in GitHub with
required reviewers
2. **Secrets:** Add required secrets (AWS credentials, Infracost API key, etc.)
3. **Branch Protection:** Require PR reviews and status checks before merging
4. **TFLint Config:** Add `.tflint.hcl` configuration file for custom rules

## Workflow Dependencies

- **Pull Request Flow:** Validation → Security → Planning (all must pass)
- **Deployment Flow:** Only runs after successful merge to main
- **Documentation:** Runs independently and auto-commits updates

This setup ensures infrastructure changes are validated, secure, reviewable, and
properly documented before deployment.
