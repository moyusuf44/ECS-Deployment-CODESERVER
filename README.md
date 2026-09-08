# Code Server on AWS ECS Fargate

> A cloud-hosted development environment built to learn what it takes to take a containerised application from a local machine to a secure, automated AWS deployment.

## Table of Contents

## Table of Contents

- [Why I Built This](#why-i-built-this)
- [What I Built](#what-i-built)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Deployment](#deployment)
- [CI/CD](#cicd)
- [Security](#security)
- [What I Learned](#what-i-learned)
- [Future Improvements](#future-improvements)

---

## Why I Built This

This was one of my first projects while learning **Cloud and DevOps engineering**.

I didn't want to stop at running Docker containers locally. I wanted to understand what happens when you take a containerised application and make it accessible as a real service.

I chose **code-server** because it turns a browser into a development environment. That gave me something practical to deploy while learning:

* Linux and Docker
* AWS networking
* Container orchestration
* Infrastructure as Code
* HTTPS and DNS
* CI/CD

The goal wasn't to build code-server itself.

**The goal was to learn how to build and operate the infrastructure around an application.**

---

## What I Built

I deployed code-server as a Docker container running on **AWS ECS Fargate**.

The infrastructure is provisioned with **Terraform**, with **GitHub Actions** handling the deployment workflow.

The deployment includes:

* AWS VPC
* ECS Fargate
* Amazon ECR
* Application Load Balancer
* AWS Certificate Manager
* Cloudflare DNS
* Terraform remote state
* GitHub Actions CI/CD

The result is a browser-accessible development environment available through HTTPS.

---

## Architecture

```text
User
  |
  | HTTPS
  v
Cloudflare
  |
  v
Application Load Balancer
  |
  v
ECS Fargate
  |
  v
code-server Container
  ^
  |
Amazon ECR
```

Terraform manages the infrastructure:

```text
Terraform
   |
   +-- VPC
   +-- ECR
   +-- ECS
   +-- ALB
   +-- ACM
   +-- Cloudflare
```

---

## Tech Stack

| Technology                | Purpose                 |
| ------------------------- | ----------------------- |
| AWS ECS Fargate           | Container hosting       |
| Amazon ECR                | Container image storage |
| Application Load Balancer | Traffic routing         |
| AWS ACM                   | HTTPS certificate       |
| Amazon VPC                | Networking              |
| Terraform                 | Infrastructure as Code  |
| Docker                    | Containerisation        |
| Cloudflare                | DNS                     |
| GitHub Actions            | CI/CD                   |
| Amazon S3                 | Terraform remote state  |
| Linux                     | Development environment |

---

## Deployment

### Prerequisites

* AWS account
* Cloudflare account and domain
* Docker
* Terraform
* AWS CLI

### Deploy

Clone the repository:

```bash
git clone <repository-url>
cd Infrastructure-terra
```

Initialise Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review the changes:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

Once the ECS service is running and the ALB reports healthy targets, the code-server environment can be accessed through the configured HTTPS domain.

---

## CI/CD

GitHub Actions automates the deployment process.

```text
GitHub
   |
   v
GitHub Actions
   |
   +--> Build Docker image
   |
   +--> Push image to ECR
   |
   +--> Terraform plan
   |
   +--> Terraform apply
   |
   v
AWS
```

The workflow can also be triggered manually using **workflow dispatch**.

Sensitive values such as AWS credentials, Cloudflare credentials and the code-server password are stored as GitHub Secrets.

---

## Security

The Application Load Balancer accepts public web traffic on:

* `80` — HTTP
* `443` — HTTPS

The ECS service does **not** allow unrestricted public access.

Instead, the ECS security group only accepts traffic from the Application Load Balancer.

```text
Internet
   |
   v
ALB
   |
   | Allowed
   v
ECS
```

Terraform state is stored remotely in Amazon S3 to avoid relying on a local state file.

---

## What I Learned

This project changed how I approached cloud engineering.

I started with the idea of **"how do I deploy this?"**

It quickly became:

**"What has to exist for this application to actually work?"**

That meant dealing with networking, security groups, container ports, health checks, DNS, certificates, IAM, Terraform state and deployment failures.

Some of the most useful lessons came from things going wrong — particularly debugging ECS health checks, networking issues and container deployment failures.

This project was less about code-server and more about learning how the pieces of a cloud environment fit together.

---

## Future Improvements

If I continued developing this project, I would add:

* ECS auto scaling
* CloudWatch monitoring and alerts
* Container vulnerability scanning
* More restrictive IAM permissions
* Automated health checks
* Improved secret management

---

## Screenshots

### Successful Deployment

![Successful Deployment](image-3.png)

### Code Server Running

![Code Server](image-2.png)

---

## Author

**Mohamed Mahmoud Yusuf**

Cloud / DevOps Engineering

This project represents an early step in my journey from learning individual technologies to understanding how they work together to build useful systems.
