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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnofP0ylZthU9s1Uq382/h1Un89/Ctnuuy1JGxBisXHNR5Y1uHPFHY8cLvBNM7eay7EKWvIybm7pmUiDhiADOVzIM3Axo8KZdQI0fKMnjnrklsy+QDHBLSYtTDM+Gjle/hgvMCAlnvTVT19tuzAzhH2tJMemeMLVVumwyVrKQ75UQ1syFatBb5hkRBi9di5IDtykRavIkZ+eDIAW79oJ/YfzsybCq+hGWianKxPNNFYzNoAbLFzHsDKGz/Y0J2C4v1JxIgb7LmUix9dqmzVmDHFzjIXwiXxM2+Wj6Vw6P8o2p256nr1INhWe9Z8O9GX3uZ4n3ez3JNDe8ao1gui5YJJyRH6XeAK2yE/N2g7USb6ik+x6tsAPylbdzS58f1TSAo2iP+7eSJpQ3f6PWQFhV3gwR0ip55/hKHn8XG0a09pXQnEpdKqhe6ewU7EskXoQ8F5zv1hQWhBZXkUCt5CSIW1FjJ+GME/l8xWPam/pmvLmmTYFtIBq9tnLVpcr8jdq0= pat@thinkpad"
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = "eu-west-3a"
  size              = 8

  tags = {
    Name = "Terraform-EBS"
  }
}