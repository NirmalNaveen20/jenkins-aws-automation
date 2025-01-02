# Jenkins Installation on AWS EC2 using Terraform

## Project Overview
This project automates the deployment of a Jenkins server on AWS EC2 using Terraform. It covers the creation of an EC2 instance, bootstrapping Jenkins installation, setting up security groups, and creating an S3 bucket for Jenkins artifacts storage. The goal is to simplify and standardize Jenkins deployment for CI/CD workflows. 🛠️

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Installation and Setup](#installation-and-setup)
3. [Terraform Configuration](#terraform-configuration)
   - [Main Terraform File](#main-terraform-file)
   - [Jenkins Bootstrap Script](#jenkins-bootstrap-script)
4. [Security Group Configuration](#security-group-configuration)
5. [S3 Bucket for Jenkins Artifacts](#s3-bucket-for-jenkins-artifacts)
6. [Testing the Deployment](#testing-the-deployment)
7. [Advanced and Complex Tasks](#advanced-and-complex-tasks)

---

## Prerequisites
Before you begin, ensure you have the following:
- 🆓 **AWS Free Tier Account**
- ✅ **AWS CLI configured** with IAM credentials
- 📦 **Terraform Installed** (latest version recommended)
- 📚 **Basic knowledge** of AWS
- 💻 **Editor** such as AWS Cloud9 or Visual Studio Code
- 💡 **Basic Linux skills** (for troubleshooting and customization)

---

## Installation and Setup
### Steps to Initialize the Project:
1. **Create a working directory** and navigate into it:
   ```bash
   mkdir jenkins-terraform && cd jenkins-terraform
   ```
2. **Create essential Terraform and script files:**
   ```bash
   touch main.tf install_jenkins.sh providers.tf variables.tf
   ```

---

## Terraform Configuration

### Main Terraform File (`main.tf`)
```hcl
resource "aws_instance" "jenkins-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data              = file("./install_jenkins.sh")
  tags = {
    Name = "Myweek2025project"
  }
}

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.bucket
  tags = {
    Name = "Myweek2025project"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
```

### Jenkins Bootstrap Script (`install_jenkins.sh`)
```bash
#!/bin/bash
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo dnf install java-11-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

---

## Security Group Configuration
### Security Group for Jenkins (`main.tf`)
```hcl
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow Port 22 and 8080"

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins Traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## S3 Bucket for Jenkins Artifacts
### S3 Configuration in `main.tf`
```hcl
resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = var.bucket
  tags = {
    Name = "Myweek2025project"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  acl    = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
```

---

## Testing the Deployment
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```
3. **Apply the configuration:**
   ```bash
   terraform apply
   ```
4. **Access Jenkins:**  
   Open your browser and navigate to `http://<Public_IP>:8080`, replacing `<Public_IP>` with the public IP of your EC2 instance.

---

## Advanced and Complex Tasks
### Advanced Task: Add Variables for Configuration
Create a `variables.tf` file to manage configurable values:
```hcl
variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "ami_id" {
  default = "ami-01816d07b1128cd2d"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "terraformjnk"
  type    = string
}

variable "bucket" {
  default = "jenkins-s3-bucket-2025"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}
```

### Complex Task: Add IAM Role for S3 Access
```hcl
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_s3_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
```

---

### 🌟 Happy Automating!  
With this project, you can confidently deploy a Jenkins server on AWS EC2 using Terraform. Customize it further for your team's specific CI/CD needs. 🙌