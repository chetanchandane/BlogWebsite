

 Project Overview
This project involves deploying a Dockerized Node.js application on AWS using Terraform, Ansible, Docker, Prometheus, and Grafana.

 Steps

1. Dockerize the Application:
   - Created a Dockerfile to containerize the Node.js app.

2. Infrastructure Setup with Terraform:
   - Used Terraform to create AWS infrastructure: VPC, Subnet, Internet Gateway, Security Group, and an EC2 instance.
   - Configured security groups for HTTP (port 3000) and SSH access.

3. Instance Access:
   - Generated an SSH key pair for instance access.

4. Application Deployment with Ansible:
   - Wrote an Ansible playbook to install Docker on the EC2 instance and deploy the Docker container.

 To-Do
- Add monitoring with Prometheus and Grafana.
- Implement CICD pipeline using Jenkins

 Usage
1. Run `terraform apply` to set up the infrastructure.
2. Use Ansible to deploy the application to the EC2 instance.
3. Access the application via `http://<instance_public_ip>:3000`.


