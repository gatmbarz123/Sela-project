# Sela-project AWS Services Display

This project is a cloud-based solution designed to display information about your AWS account, including the services and resources in use. Below is a breakdown of the system architecture, tools used, and deployment processes.


![][image]

## Features
- Displays details about AWS services in your account across all regions.
- Uses Terraform for infrastructure provisioning.
- Implements a CI/CD pipeline for automated deployment.
- Private and secure architecture with no public internet access to resources.

## AWS Services Used
The system utilizes the following AWS services:

- **EC2**: Hosts the application in a Docker container.
- **VPC**: Provides a secure network environment.
- **ALB (Application Load Balancer)**: Exposes private resources securely to the internet.
- **Route 53**: Manages DNS records for user-friendly domain access.
- **DynamoDB**: Stores service data as key-value pairs.
- **IAM**: Handles secure access and permissions.
- **ECR (Elastic Container Registry)**: Stores Docker images.
- **Lambda**: Retrieves AWS account service data and updates DynamoDB.
- **EventBridge**: Triggers Lambda functions automatically.
- **SSM (Systems Manager)**: Automates EC2 instance configuration and Docker container deployment.

## Architecture Overview

1. **Infrastructure Setup with Terraform**
   - Provisions private and public subnets.
   - Deploys NAT Gateways in public subnets for internet access.
   - Uses variables (`vars`) for flexible configurations and supports multiple workspaces (e.g., `DEV`, `PROD`, `DEMO`).
   - Automates infrastructure deployment via `terraform apply`.

2. **Lambda Function**
   - Written in Python using Boto3.
   - Collects AWS service details across regions and stores them in DynamoDB.

3. **DynamoDB**
   - Stores AWS service data as key-value pairs for quick access.

4. **EC2 Instance with Docker**
   - Hosts the web application to display DynamoDB data using Jinja2 templates.
   - Deployed in private subnets and exposed via ALB.

5. **Application Load Balancer (ALB)**
   - Routes internet traffic securely to the private EC2 instance.
   - Integrates with Route 53 to provide a user-friendly domain name.

6. **Docker Deployment**
   - Uses SSM to install Docker and pull the image from ECR.
   - Ensures secure communication within the VPC using VPC Endpoints.

## CI/CD Pipeline

- **CI (Continuous Integration)**
  - Builds the Docker image using the following files:
    - `app.py`: Application logic.
    - `Dockerfile`: Defines the Docker image.
    - `index.html`: Web application UI.
    - `requirements.txt`: Python dependencies.
  - Runs on GitHub Actions.

- **CD (Continuous Deployment)**
  - Deploys infrastructure using Terraform.
  - Executes tests and applies changes.

## Security Measures
- No direct public access to private resources.
- SSM ensures secure configuration without the need for public internet.
- ALB and Route 53 provide secure access to the application.
- Security Groups (SG) are configured with the minimal required permissions to ensure enhanced security.

## Usage
1. Clone the repository.
2. Configure the Terraform variables in `vars` to match your environment.
3. Set up the CI/CD pipeline in your GitHub repository.
4. Run the deployment process to provision infrastructure and deploy the application.

---

This project provides an automated, secure, and scalable solution for managing and displaying AWS account information within a private cloud environment.


[image]:./Images/sela-project.png