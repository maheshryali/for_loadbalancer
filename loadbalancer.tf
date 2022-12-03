resource "aws_lb_target_group" "thisisforlb" {
  port              = 80
  protocol          = "HTTP"
  vpc_id            = aws_vpc.loadbalvpc.id
  target_type       = "instance"
}

resource "aws_lb_target_group_attachment" "instanceattachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.thisisforlb.arn
  target_id        = aws_instance.web[count.index].id

  depends_on = [
    aws_lb_target_group.thisisforlb
  ]
}

resource "aws_lb" "lbfornginx" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.forinstances.id] 
  subnet_mapping {
    subnet_id = aws_subnet.subnets[0].id
  }
  subnet_mapping {
    subnet_id = aws_subnet.subnets[1].id
  }

  tags = {
    Name = "lb_for_nginx"
  }

  depends_on = [
    aws_lb_target_group.thisisforlb
  ]
}