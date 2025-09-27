# Bicep GitHub Actions Workflows

This repository contains GitHub Actions workflows for managing Azure Bicep infrastructure with proper validation, security, and deployment practices.

## Workflow Overview

### 1. Validation (`bicep-validate.yaml`)
**Triggers:** Pull requests with Bicep file changes
**Purpose:** Ensure code quality and syntax correctness

**What it does:**
- Lints Bicep files with `az bicep lint`
- Builds Bicep files to validate syntax with `az bicep build`
- Validates templates against Azure Resource Manager

**Why:** Catches syntax errors early, ensures templates are deployable, and validates against Azure ARM schema.

### 2. What-If Analysis (`bicep-whatif.yaml`)
**Triggers:** Pull requests with Bicep file changes
**Purpose:** Preview infrastructure changes before deployment

**What it does:**
- Runs `az deployment group what-if` to show planned changes
- Posts what-if results as PR comments for review
- Provides cost estimation guidance

**Why:** Allows teams to review infrastructure changes before deployment and understand the impact on existing resources.

### 3. Security Scanning (`bicep-security.yaml`)
**Triggers:** Pull requests with Bicep file changes
**Purpose:** Identify security misconfigurations and policy violations

**What it does:**
- Converts Bicep to ARM templates for broader scanning support
- Runs Checkov for security best practices
- Executes PSRule for Azure-specific compliance checks
- Validates against Azure Security Benchmark
- Uploads results to GitHub Security tab

**Why:** Prevents security vulnerabilities and policy violations from being deployed to Azure.

### 4. Deployment (`bicep-deploy.yaml`)
**Triggers:** Pushes to main branch with Bicep file changes
**Purpose:** Deploy approved infrastructure changes to Azure

**What it does:**
- Authenticates with Azure using service principal
- Validates templates before deployment
- Deploys using `az deployment group create`
- Retrieves and reports deployment outputs
- Posts deployment status as commit comment

**Why:** Safely deploys infrastructure changes after all validations pass with proper Azure authentication.

### 5. Documentation (`bicep-docs.yaml`)
**Triggers:** Pull requests with Bicep file changes
**Purpose:** Keep documentation current with template changes

**What it does:**
- Generates ARM templates for documentation
- Extracts parameters, outputs, and resources from Bicep files
- Creates markdown documentation for each template
- Updates main README with documentation links
- Commits documentation changes back to PR

**Why:** Ensures documentation stays synchronized with infrastructure code changes.

## Setup Requirements

### Azure Authentication
1. **Service Principal:** Create Azure service principal with appropriate permissions
2. **GitHub Secrets:** Add required secrets:
   - `AZURE_CREDENTIALS`: Service principal credentials (JSON format)
   - `AZURE_RG`: Target resource group name
   - `AZURE_SUBSCRIPTION_ID`: Azure subscription ID

### Environment Protection
1. **Production Environment:** Configure in GitHub with required reviewers
2. **Branch Protection:** Require PR reviews and status checks before merging

### Parameters File
Create `parameters.json` files for your Bicep templates with required parameters.

## Workflow Dependencies

- **Pull Request Flow:** Validation → Security → What-If (all must pass)
- **Deployment Flow:** Only runs after successful merge to main
- **Documentation:** Runs independently and auto-commits updates

## Azure CLI Requirements

All workflows require Azure CLI with Bicep extension. The workflows automatically:
- Install latest Azure CLI
- Authenticate using provided credentials
- Set the correct subscription context

This setup ensures Bicep templates are validated, secure, reviewable, and properly documented before deployment to Azure.