resource "aws_instance" "python-app" {
  ami           = data.aws_ami.python-app.id
  instance_type = "t2.micro"
  security_groups = [
    "sg-0a4fb2e65a72c9957",
    "sg-51d9c537"
  ]
  key_name  = "Terraform-SSH"
  subnet_id = "subnet-8900f4e1"

  tags = {
    Name = "Terraform-EC2-Python-App"
  }

  depends_on = [aws_instance.mongodb]

  connection {
    type  = "ssh"
    host  = aws_instance.python-app.public_ip
    user  = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
    port  = 22
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"MONGODB_PRIVATE_IP=${data.aws_instances.mongodb.private_ips[0]}\" >> /home/ubuntu/app.env",
      "sudo systemctl restart flask-python-app.service",
    ]
  }

}
