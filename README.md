# Terraform AWS DVWA Docker EC2 Instance
This Terraform code repository contains the necessary configuration to deploy a Dockerized version of Damn Vulnerable Web Application (DVWA) on an Amazon EC2 instance. DVWA is a vulnerable web application used for security testing and learning.

## Features
- Deploys DVWA web application on an EC2 instance.
- Accessible on port 80 of the EC2 instance's public IP address.
- Public IP address of the EC2 instance is displayed after execution.


## Prerequisites
Before running this Terraform configuration, ensure you have the following prerequisites:
- AWS account with appropriate permissions.
- Terraform installed on your local machine.
- AWS CLI configured with your credentials.

## Usage

1. Clone this repository to your local machine.
```bash
  git clone https://github.com/imusabkhan/Terraform.git
```
2. Navigate to the directory containing the Terraform code.
```bash
  cd Terraform
```
3. Run `terraform init` to initialize the Terraform configuration.
4. Run `terraform plan` to review the changes that will be applied.
5. Run `terraform apply` to create the EC2 instance.
6. Once the execution is complete, the public IP address of the EC2 instance will be displayed.

#### Note: To destroy the resources created with Terraform, use the following command:
```sh
terraform destroy -auto-approve
```

## Accessing DVWA

After the EC2 instance is provisioned, you can access DVWA by navigating to the public IP address of the instance in your web browser, followed by port 80.
