packer {
  required_plugins {
    amazon-python = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name              = "python-app-ami"
  force_deregister      = true
  force_delete_snapshot = true
  instance_type         = "t2.micro"
  region                = "eu-west-3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "python-app-ami-build"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "app.py"
    destination = "/tmp/app.py"
  }

  provisioner "file" {
    source      = "flask-python-app.service"
    destination = "/tmp/flask-python-app.service"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get --yes upgrade",
      "sudo apt-get update",
      "sudo apt-get --yes upgrade",
      "sudo apt-get update",
      "sudo apt-get --yes -f install python3-pip",
      "sudo -H pip3 install flask",
      "sudo -H pip3 install pymongo",
      "cp /tmp/app.py /home/ubuntu/app.py",
      "chmod 664 /home/ubuntu/app.py",
      "chown ubuntu:ubuntu /home/ubuntu/app.py",
      "touch /home/ubuntu/app.env",
      "chmod 664 /home/ubuntu/app.env",
      "chown ubuntu:ubuntu /home/ubuntu/app.env",
      "sudo cp /tmp/flask-python-app.service /etc/systemd/system/flask-python-app.service",
      "sudo chmod 664 /etc/systemd/system/flask-python-app.service",
      "sudo chown root:root /etc/systemd/system/flask-python-app.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable flask-python-app.service",
    ]
  }
}
