data "aws_ami" "python-app" {
  most_recent      = true
  owners           = ["025340162599"]

  filter {
    name   = "name"
    values = ["python-app-ami"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "mongodb" {
  most_recent      = true
  owners           = ["025340162599"]

  filter {
    name   = "name"
    values = ["mongodb-ami"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_instances" "mongodb" {
  filter {
    name   = "tag:Name"
    values = ["Terraform-EC2-MongoDB"]
  }

  instance_state_names = ["pending", "running"]

  depends_on = [aws_instance.mongodb]
}