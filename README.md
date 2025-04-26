
# ecs-terraform-pokemon

## Random Pokémon Flask App on AWS ECS

This project demonstrates a scalable Flask web application that displays random Pokémon. The application is deployed using AWS ECS Fargate and integrated with an Application Load Balancer (ALB) and Auto Scaling for high availability and performance.

---

## Features

- Python Flask web application
- Displays a random Pokémon on each page load
- Dockerized and deployed using Amazon ECS Fargate
- Exposed via an Application Load Balancer (ALB)
- Auto Scaling based on CPU utilization and ALB request count
- CI/CD pipeline with GitHub Actions

---
## 📸 Screenshot of the S3 Bucket Structure

Here’s a screenshot of the S3 bucket used in the project, showcasing the structure of the state files. The design is based on best practices for organizing state files, ensuring better management and versioning. This structure helps maintain consistency and prevents potential conflicts during deployment. 
![S3 Bucket Structure](https://github.com/ChenBello/ecs-terraform-pokemon-states/blob/650c31d85d6f80b38c28b6af957ee32695e67fdd/IMG_2020.png)

---
## Architecture Overview

| Component                    | Purpose                               |
|------------------------------|---------------------------------------|
| Amazon ECS Fargate           | Hosts the containerized application   |
| Application Load Balancer    | Routes traffic to the ECS service     |
| Auto Scaling | Adjusts the number of running tasks based on CPU usage and incoming request count |
| Amazon ECR                   | Stores Docker images                  |
| GitHub Actions               | Handles CI/CD automation              |

---

## Prerequisites

- AWS account with necessary IAM permissions
- Terraform installed
- Docker installed
- GitHub repository with required secrets and variables

---

## Deployment Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/ChenBello/ecs-terraform-pokemon.git
cd ecs-terraform-pokemon
```

### 2. Configure Terraform Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update `terraform.tfvars` with your AWS, VPC, and application-specific settings.

### 3. (Optional) Build Docker Image Locally

```bash
cd application
docker build -t pokemon-flask-app .
```

### 4. Push the Image to ECR or Docker Hub

Follow your container registry instructions for login and image push.

### 5. Deploy Infrastructure with Terraform

```bash
cd infrastructure
terraform init
terraform apply
```

### 6. Access the Application

The application will be accessible via the ALB DNS name output by Terraform. (ECS Auto Scaling adjusts task count based on CPU usage and ALB request count).

---

## CI/CD with GitHub Actions

A GitHub Actions workflow is included for continuous deployment.

**Workflow File:** `.github/workflows/DeployApp.yml`

### What It Does

- Detects changes in the `application/` directory on push to `main`
- Builds and pushes the Docker image to Amazon ECR
- Triggers a new ECS deployment
- Sends a Slack notification on success or failure
- Supports manual deployment via workflow dispatch

---

## GitHub Secrets (Settings → Secrets and variables → Actions)

| Name                  | Description                     |
|-----------------------|---------------------------------|
| AWS_ACCESS_KEY_ID     | IAM access key                  |
| AWS_SECRET_ACCESS_KEY | IAM secret key                  |
| AWS_ACCOUNT_ID        | AWS account ID                  |
| SLACK_WEBHOOK_URL     | Slack incoming webhook URL      |

---

## Repository Variables (Settings → Variables)

| Name                  | Description                             |
|-----------------------|-----------------------------------------|
| ECR_BACKEND_IMAGE     | Name of the ECR repository              |
| AWS_DEFAULT_REGION    | AWS region (e.g., us-east-1)            |
| ECS_CLUSTER           | Name of the ECS cluster                 |
| ECS_BACKEND_SERVICE   | Name of the ECS service                 |

---

## Deployment Process Overview

1. Checkout repository
2. Authenticate with AWS and ECR
3. Build Docker image from `application/`
4. Push image to ECR with `latest` tag
5. Update ECS service to trigger new deployment
6. Send deployment status to Slack

---

## Example Slack Notifications

- Deployment succeeded
- Deployment failed

Messages include deployer info, commit message, ECS service, and cluster.

---

## Terraform State Structure

This project follows an opinionated **modular structure** with separate Terraform states for better isolation, scalability, and management. The deployment is split into three main stages:

| Stage        | State File Path                         | Description                                                                 |
|--------------|------------------------------------------|-----------------------------------------------------------------------------|
| `bootstrap`  | `states/bootstrap/terraform.tfstate`     | Creates the Terraform backend (S3 bucket and DynamoDB table for locking).  |
| `network`    | `states/network/terraform.tfstate`       | Provisions the base networking layer: VPC, subnets, NAT, IGW, route tables.|
| `ecs-fargate`| `states/ecs-fargate/terraform.tfstate`   | Deploys the application on ECS Fargate with ALB, Auto Scaling, and IAM.    |

Each environment loads outputs from the previous stage using `terraform_remote_state`, ensuring a loosely coupled and composable infrastructure design.

### Dependency Flow

```text
bootstrap → network → ecs-fargate
