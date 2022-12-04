resource "aws_instance" "web" {
  count                       =   2  
  ami                         =   data.aws_ami.ubuntu.id
  associate_public_ip_address =   true
  instance_type               =   "t2.micro" 
  key_name                    =   "newkey2"
  subnet_id                   =   aws_subnet.subnets[count.index].id 
  vpc_security_group_ids      =   [aws_security_group.forinstances.id] 

  provisioner "remote-exec" {
    connection {
    type        =  "ssh"
    user        =  "ubuntu"
    private_key =  file("~/.ssh/id_rsa")
    host        =  aws_instance.web[0].public_ip
  }
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"
    ]
  }

  tags = {
    Name = var.instance_names[count.index]
  }
}

