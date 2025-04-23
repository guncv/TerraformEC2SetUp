# Terraform EC2 Setup with Wordpress and MariaDB

## Overview

This project utilizes **Terraform** to set up an AWS EC2 instance with a **WordPress** application, **MariaDB** database, and integration with **S3** for storage. It automates the process of provisioning and managing the infrastructure required to run a WordPress site on AWS.

### Components Set Up by Terraform:
1. **VPC**: Creates a Virtual Private Cloud (VPC) for networking.
2. **EC2**: Launches an EC2 instance to host the WordPress application.
3. **MariaDB**: Configures MariaDB as the database server for WordPress.
4. **S3**: Sets up an S3 bucket for object storage (e.g., images, media for WordPress).
5. **Security**: Configures necessary security groups to ensure secure communication between components.
6. **Network Setup**: Defines subnets, NAT Gateway, and network interfaces for proper network routing.
7. **Scripts**: Includes setup scripts for WordPress (`setup-wordpress.sh`) and MariaDB (`setup-mariadb.sh`).

## Prerequisites

Before running the Terraform configuration, ensure the following:

- **AWS Account**: An active AWS account.
- **Terraform**: Terraform v0.12 or higher.
- **AWS CLI**: Configured AWS CLI with the necessary permissions (IAM roles for EC2, S3, etc.).

### Setting Up Terraform

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/guncv/TerraformEC2SetUp.git
   cd https://github.com/guncv/TerraformEC2SetUp.git
   ```

2. **Set AWS Region in `terraform.tfvars`:**
   Update your region in the `terraform.tfvars` file:
   ```hcl
   aws_region = "us-west-2"
   ```

3. **Initialize Terraform:**
   Run the following command to initialize the working directory with the necessary providers and modules:
   ```bash
   terraform init
   ```

4. **Review Configuration:**
   Run the following command to see what changes Terraform plans to apply:
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   Apply the configuration to create resources on AWS:
   ```bash
   terraform apply
   ```

   When prompted, type `yes` to proceed with creating the infrastructure.

## Directory Structure

The following is the directory structure for the project:

```
.
├── README.md              # Project Overview
├── ec2.tf                 # EC2 Instance Setup
├── eip.tf                 # Elastic IP Setup
├── iam.tf                 # IAM Role Setup
├── internet_gateway.tf    # Internet Gateway Setup
├── keypair.tf             # Key Pair for SSH Access
├── main.tf                # Main Terraform Configuration
├── nat_gateway.tf         # NAT Gateway Setup
├── network_interface.tf   # Network Interface Setup
├── output.tf              # Output values for easy access
├── s3.tf                  # S3 Bucket Setup
├── security.tf            # Security Group Setup
├── setup-mariadb.sh       # MariaDB Setup Script
├── setup-wordpress.sh     # WordPress Setup Script
├── setup.tf               # Additional Terraform Configuration
├── subnet.tf              # Subnet Setup
├── terraform.tfvars       # Variable definitions
├── variable.tf            # Input Variable Definitions
├── vpc.tf                 # VPC Setup
└── vpc_endpoint.tf        # VPC Endpoint Configuration
```

## Setup Scripts

1. **WordPress Setup (`setup-wordpress.sh`)**:
   - This script configures the EC2 instance to run WordPress.
   - It installs necessary packages, configures WordPress, and sets up the database connection.

2. **MariaDB Setup (`setup-mariadb.sh`)**:
   - This script sets up the MariaDB server on the EC2 instance.
   - It configures the database and ensures connectivity to WordPress.

## Resources Created by Terraform
- **EC2 Instance**: A virtual machine running WordPress.
- **VPC**: A Virtual Private Cloud with subnets, routing, and Internet/NAT Gateways.
- **Security Groups**: Configured to allow traffic on necessary ports (HTTP, HTTPS, MySQL).
- **S3 Bucket**: Used to store media files for WordPress.
- **IAM Role**: For EC2 to interact with other AWS resources like S3.

## Cleaning Up

To destroy the infrastructure once you're done with it, run the following command:

```bash
terraform destroy
```

This will delete all the resources that were created by Terraform.

## Troubleshooting

- Ensure that your **AWS CLI** is configured correctly with sufficient IAM permissions.
- Make sure that the region set in `terraform.tfvars` matches the region where you want the infrastructure to be created.
- Check security group settings to ensure the correct ports are open for HTTP, HTTPS, and MySQL.

## Contributions

Feel free to fork the repository and submit pull requests with any improvements or new features. Contributions are welcome!

---