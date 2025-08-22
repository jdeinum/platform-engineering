# 🚀 GitHub Actions

**GitHub Actions** is a powerful feature built into GitHub that enables
developers to **automate workflows** directly within their repositories. It
allows you to respond to events—like pushing code, opening pull requests, or
creating issues—by triggering custom workflows.

## 🛠️ What Can You Use It For?

- ✅ **CI/CD (Continuous Integration/Continuous Deployment)** Automatically
  build, test, and deploy your code whenever changes are made.

- 🧪 **Automated Testing** Run unit, integration, or end-to-end tests across
  multiple platforms and environments.

- 🧹 **Code Quality Checks** Enforce linting, formatting, and other quality
  standards before code is merged.

- ☁️ **DevOps & Cloud Deployments** Automate infrastructure tasks or deploy
  applications to cloud services like AWS, Azure, or GCP.

## 📄 How It Works

Workflows are defined using **YAML** files stored in the `.github/workflows/`
directory of your repo. These workflows are made up of **jobs** that run on
virtual machines called **runners**.

Each workflow can be triggered by:

- Events (e.g. `push`, `pull_request`, `issue`)
- Manual triggers (`workflow_dispatch`)
- Scheduled times (`cron` jobs)

## Examples

This repository contains several examples on hhow to use github actions. We'll
be focusing our attention on the actual building and deploying of an application
inn Rust, but also include some workflows for cloud deployments. For each of
these, see the READMEs below:

1. [Rust](./rust.md)
