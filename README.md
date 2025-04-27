
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

## Architecture Overview

| Component                    | Purpose                               |
|------------------------------|---------------------------------------|
| Amazon ECS Fargate           | Hosts the containerized application   |
| Application Load Balancer    | Routes traffic to the ECS service     |
| Auto Scaling                 | Adjusts the number of running tasks based on CPU usage and incoming request count |
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
git clone https://github.com/ChenBello/ecs-terraform-pokemon-states.git
cd ecs-terraform-pokemon-states
```

### 2. Configure Terraform Variables

Copy the example terraform.tfvars files for each stage (in this case, this is only needed for the 'ecs-fargate' stage):
```bash
cp infrastructure/bootstrap/terraform.tfvars.example infrastructure/bootstrap/terraform.tfvars
cp infrastructure/network/terraform.tfvars.example infrastructure/network/terraform.tfvars
cp infrastructure/ecs-fargate/terraform.tfvars.example infrastructure/ecs-fargate/terraform.tfvars
```
Update each terraform.tfvars file with your AWS, VPC, and application-specific settings.

### 3. (Optional) Build Docker Image Locally

If you want to build the Docker image locally, run the following commands:
```bash
cd application
docker build -t pokemon-flask-app .
```

### 4. Push the Image to ECR or Docker Hub

Follow the appropriate container registry instructions to log in and push the Docker image (either to ECR or Docker Hub).

### 5. Deploy Infrastructure with Terraform

The deployment is split into three stages. You need to apply the configurations in the following order:

#### Stage 1: Bootstrap

This stage sets up the Terraform backend (S3 bucket and DynamoDB table for locking). Run the following commands:
```bash
cd infrastructure/bootstrap
terraform init
terraform apply
```
#### Stage 2: Network

The second stage provisions the base networking layer (VPC, subnets, NAT, etc.). Run the following commands:
```bash
cd infrastructure/network
terraform init
terraform apply
```
#### Stage 3: ECS-Fargate

Finally, deploy the application on ECS Fargate. Run the following commands:
```bash
cd infrastructure/ecs-fargate
terraform init
terraform apply
```
### 6. Access the Application

The application will be accessible via the ALB DNS name output by Terraform. ECS Auto Scaling will automatically adjust the task count based on CPU usage and ALB request count.

This setup includes a CI/CD pipeline with GitHub Actions, which will trigger deployments when changes are pushed to the main branch. Additionally, the infrastructure is divided into separate modules (bootstrap, network, ecs-fargate) for better organization and isolation of state files.

---

## 📸 Screenshot of the Architecture

Here’s a diagram of the project’s architecture, showcasing the key components and how they interact. While the diagram illustrates the use of **AWS CodePipeline**, **AWS CodeDeploy** and **AWS CodeBuild** for CI/CD, in this project, **GitHub Actions** is used to manage the continuous integration and deployment process.

![Architecture Diagram](https://github.com/ChenBello/ecs-terraform-pokemon-states/blob/aea20ae93de8aa5a00cf5924aa8745f5bf0f67ff/_Pokemon-app-terraform_.drawio.png)

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
# Terraform State Management

This project uses a remote backend to store the Terraform state file securely:

- **S3 Bucket**: Stores the Terraform `.tfstate` file.
- **DynamoDB Table**: Handles state locking and consistency to avoid concurrent operations.

## Diagram

[![Terraform State Architecture](./state-file.drawio.png)](./state-file.drawio.png)

### 💡 Why S3 + DynamoDB?

Using **S3** to store the Terraform state file allows for versioning and persistence. By adding **DynamoDB** for state locking, we ensure that concurrent Terraform operations are safely handled, preventing conflicts during deployments. This setup is designed to enhance the reliability and scalability of infrastructure provisioning.

## Screenshot of the S3 Bucket Structure

Below you can find a screenshot of the actual S3 bucket structure used for Terraform state files:

![S3 Bucket Structure](https://github.com/ChenBello/ecs-terraform-pokemon-states/blob/650c31d85d6f80b38c28b6af957ee32695e67fdd/IMG_2020.png)

---

## Terraform State Structure

This project follows an opinionated **modular structure** with separate Terraform states for better isolation, scalability, and management. The deployment is split into three main stages:

### Stages and State Files:

- **bootstrap**:  
  This stage is responsible for setting up the Terraform backend (S3 bucket and DynamoDB table for locking).
  - **State file path**: Stored locally during bootstrap (since the remote backend does not exist yet).
  - **Description**: Creates the Terraform backend (S3 bucket and DynamoDB table for locking).

- **network**:  
  This stage provisions the base networking layer.
  - **State file path**: `states/network/terraform.tfstate`
  - **Description**: Provisions the base networking layer: VPC, subnets, NAT, IGW, and route tables.

- **ecs-fargate**:  
  This stage deploys the application on ECS Fargate.
  - **State file path**: `states/ecs-fargate/terraform.tfstate`
  - **Description**: Deploys the application on ECS Fargate with ALB, Auto Scaling, and IAM.

### Key Points:
- The **bootstrap** stage is stored locally because the remote backend does not exist yet.
- The **network** and **ecs-fargate** stages use remote backends (S3 + DynamoDB) created during bootstrap, ensuring better separation and isolation between stages.
- Each environment can load outputs from the previous stage using `terraform_remote_state`, which ensures a loosely coupled and composable infrastructure design.

### Dependency Flow:

```text
bootstrap → network → ecs-fargate
