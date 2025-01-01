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

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

