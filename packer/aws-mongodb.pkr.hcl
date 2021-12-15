packer {
  required_plugins {
    amazon-mongodb = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "mongodb" {
  ami_name              = "mongodb-ami"
  force_deregister      = true
  force_delete_snapshot = true
  instance_type         = "t2.small"
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
  name = "mongodb-ami-build"
  sources = [
    "source.amazon-ebs.mongodb"
  ]

  provisioner "file" {
    source      = "mongodb-init.js"
    destination = "/tmp/mongodb-init.js"
  }

  provisioner "file" {
    source      = "mongod.conf"
    destination = "/tmp/mongod.conf"
  }

  provisioner "shell" {
    inline = [
      "wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list",
      "sudo apt-get update",
      "sudo apt-get --yes upgrade",
      "sudo apt-get update",
      "sudo apt-get --yes upgrade",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org",
      "sudo systemctl enable mongod",
      "cp /tmp/mongodb-init.js /home/ubuntu/mongodb-init.js",
      "chmod 664 /home/ubuntu/mongodb-init.js",
      "chown ubuntu:ubuntu /home/ubuntu/mongodb-init.js",
      "sudo cp /tmp/mongod.conf /etc/mongod.conf",
      "sudo chmod 644 /etc/mongod.conf",
      "sudo chown root:root /etc/mongod.conf",
    ]
  }
}
