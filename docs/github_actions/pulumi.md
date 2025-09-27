# Pulumi GitHub Actions Workflows

This repository contains GitHub Actions workflows for managing Pulumi infrastructure with proper validation, security, and deployment practices across multiple programming languages.

## Workflow Overview

### 1. Validation (`pulumi-validate.yaml`)
**Triggers:** Pull requests with Pulumi code changes
**Purpose:** Ensure code quality, syntax correctness, and stack configuration validity

**What it does:**
- Sets up multiple language runtimes (Node.js, Python, Go, .NET)
- Installs project dependencies automatically
- Lints code using language-specific tools (pylint, eslint, gofmt, etc.)
- Validates Pulumi stack configurations
- Runs `pulumi refresh` and `pulumi preview` to validate infrastructure

**Why:** Catches syntax errors early, ensures dependencies are correct, and validates that Pulumi programs can execute successfully.

### 2. Preview (`pulumi-preview.yaml`)
**Triggers:** Pull requests with Pulumi code changes
**Purpose:** Preview infrastructure changes and estimate costs

**What it does:**
- Runs `pulumi preview` to show planned infrastructure changes
- Posts detailed preview results as PR comments
- Generates cost estimates using Infracost when supported
- Validates against Pulumi Policy as Code rules

**Why:** Allows teams to review infrastructure changes before deployment, understand resource impacts, and ensure compliance with organizational policies.

### 3. Security (`pulumi-security.yaml`)
**Triggers:** Pull requests with Pulumi code changes
**Purpose:** Identify security vulnerabilities and compliance issues

**What it does:**
- Scans code for security vulnerabilities (bandit, gosec, npm audit)
- Runs infrastructure security analysis with Checkov
- Performs secret detection with TruffleHog
- Validates against custom Pulumi policies
- Uses Semgrep for security pattern detection
- Uploads results to GitHub Security tab

**Why:** Prevents security vulnerabilities from being deployed and ensures compliance with security standards.

### 4. Deployment (`pulumi-deploy.yaml`)
**Triggers:** Pushes to main branch with Pulumi code changes
**Purpose:** Deploy approved infrastructure changes

**What it does:**
- Sets up multi-language runtime environment
- Selects production stack and validates configuration
- Runs pre-deployment validation and policy checks
- Deploys using `pulumi up`
- Performs post-deployment validation
- Exports stack state for backup
- Posts deployment status and outputs as commit comments

**Why:** Safely deploys infrastructure changes after all validations pass with proper state management.

## Setup Requirements

### Cloud Provider Authentication
Configure credentials for your target cloud provider:

**AWS:**
```yaml
secrets:
  AWS_ACCESS_KEY_ID: your-access-key
  AWS_SECRET_ACCESS_KEY: your-secret-key
  AWS_REGION: your-region
```

**Azure:**
```yaml
secrets:
  ARM_CLIENT_ID: your-client-id
  ARM_CLIENT_SECRET: your-client-secret
  ARM_SUBSCRIPTION_ID: your-subscription-id
  ARM_TENANT_ID: your-tenant-id
```

**GCP:**
```yaml
secrets:
  GOOGLE_CREDENTIALS: your-service-account-json
```

### Pulumi Configuration
1. **Pulumi Access Token:** Add `PULUMI_ACCESS_TOKEN` secret
2. **Stack Configuration:** Ensure `Pulumi.*.yaml` files exist for your environments
3. **Environment Protection:** Configure production environment with required reviewers

### Project Dependencies
Ensure your project has appropriate dependency files:
- `package.json` for Node.js/TypeScript
- `requirements.txt` for Python
- `go.mod` for Go
- `*.csproj` for .NET

## Workflow Dependencies

- **Pull Request Flow:** Validation → Security → Preview (all must pass)
- **Deployment Flow:** Only runs after successful merge to main
- **Multi-Stack Support:** Different stacks for dev/staging/production

## Language Support

The workflows support all Pulumi-supported languages:
- **TypeScript/JavaScript:** npm, eslint, type checking
- **Python:** pip, pylint, black, isort, mypy, bandit, safety
- **Go:** go mod, gofmt, go vet, gosec
- **C#/.NET:** dotnet restore, build validation

## Policy as Code

If you have Pulumi Policy Packs:
1. Place policies in a `policy/` directory
2. Include `PulumiPolicy.yaml` configuration
3. Workflows will automatically validate against policies

## Cost Management

- Infracost integration for cost estimation
- Stack output tracking for resource monitoring
- Deployment artifact retention for auditing

This setup ensures Pulumi programs are validated, secure, cost-conscious, and properly deployed across multiple cloud providers and programming languages.