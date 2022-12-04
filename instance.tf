resource "aws_instance" "web" {
  count                       =   2  
  ami                         =   data.aws_ami.ubuntu.id
  associate_public_ip_address =   true
  instance_type               =   "t2.micro" 
  key_name                    =   "keypair"
  subnet_id                   =   aws_subnet.subnets[count.index].id 
  vpc_security_group_ids      =   [aws_security_group.forinstances.id] 

  tags = {
    Name = var.instance_names[count.index]
  }
}

resource "null_resource" "fornginx" {
  triggers = {
    running_numbers = 1.0
  }
  connection {
    type        =  "ssh"
    user        =  "ubuntu"
    private_key =  file("/home/ubuntu/id_rsa")
    host        =  aws_instance.web[0].public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"
    ]
  }

  depends_on = [
    aws_instance.web
  ]
}