terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

resource "aws_key_pair" "ssh" {
  key_name   = "Terraform-SSH"
  public_key = "ssh-rsa your-public-ssh-key pb@github"
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = "eu-west-3a"
  size              = 8

  tags = {
    Name = "Terraform-EBS"
  }
}
