# GitHub Actions Scripts

This directory contains comprehensive GitHub Actions workflows for various technologies and use cases in platform engineering.

## Structure

The scripts are organized by technology/framework:

### 🦀 Rust (`rust/`)
Complete CI/CD pipeline for Rust applications including:
- **rust_check.yaml** - Code quality checks (clippy, fmt, docs)
- **rust_test.yaml** - Testing with nextest
- **rust_audit.yaml** - Security auditing
- **rust_build_*.yaml** - Multi-platform Docker builds using cargo-chef
- **chef.debian.dockerfile** - Optimized Dockerfile for Rust apps

### 🏗️ Infrastructure as Code

#### Terraform (`terraform/`)
- **terraform-validate.yaml** - Format checking, validation, and TFLint
- **terraform-plan.yaml** - Plan generation with cost estimation
- **terraform-security.yaml** - Security scanning (Checkov, TFSec, Terrascan)
- **terraform-deploy.yaml** - Production deployment with approval gates
- **terraform-docs.yaml** - Automated documentation generation

#### Bicep (`bicep/`)
- **bicep-validate.yaml** - Linting and ARM template validation
- **bicep-whatif.yaml** - Azure what-if analysis for change preview
- **bicep-security.yaml** - Security scanning and compliance checks
- **bicep-deploy.yaml** - Azure deployment with service principal auth
- **bicep-docs.yaml** - Template documentation generation

#### Pulumi (`pulumi/`)
- **pulumi-validate.yaml** - Multi-language validation (Python, TypeScript, Go, C#)
- **pulumi-preview.yaml** - Infrastructure preview with cost estimation
- **pulumi-security.yaml** - Comprehensive security scanning
- **pulumi-deploy.yaml** - Stack deployment with state management

## Key Features

- 🚀 **Multi-language support** - TypeScript, Python, Go, C#, Rust
- 🔒 **Security-first** - Integrated scanning and policy validation
- 💰 **Cost awareness** - Cost estimation and monitoring
- 📊 **Quality gates** - Automated testing and validation
- 🔄 **Optimized builds** - Smart caching and matrix builds
- 📚 **Documentation** - Automated docs generation and updates

## Usage

1. Copy the relevant workflow files to your `.github/workflows/` directory
2. Update secrets and environment variables as needed
3. Modify file paths and branch names to match your repository structure
4. Review and customize the workflow triggers and conditions

For detailed implementation guides, see the documentation in `docs/github_actions/`.
