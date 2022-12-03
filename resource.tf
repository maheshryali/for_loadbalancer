resource "aws_vpc" "loadbalvpc" {
  cidr_block = "192.168.0.0/16"
   tags = {
    Name = "loadbalvpc"
   }
}

resource "aws_subnet" "subnets" {
  count               = 2 
  availability_zone   = var.avavailability_zones[count.index] 
  vpc_id              = aws_vpc.loadbalvpc.id
  cidr_block          = cidrsubnet("192.168.0.0/16", 8, count.index)
  tags = {
    Name = var.subnet_tags[count.index]
  }
  depends_on = [
    aws_vpc.loadbalvpc
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.loadbalvpc.id
  tags = {
    Name = "igw_for_loadbal"
  }

  depends_on = [
    aws_subnet.subnets
  ]
}

resource "aws_route_table" "routetables" {
  count    =  2  
  vpc_id   =  aws_vpc.loadbalvpc.id
  tags = {
    Name = var.routetable_names[count.index]
  }
depends_on = [
  aws_internet_gateway.igw
]
}

resource "aws_route" "routes" {
  route_table_id = aws_route_table.routetables[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id     = aws_internet_gateway.igw.id

depends_on = [
  aws_route_table.routetables
]
}

resource "aws_route_table_association" "associate_public" {
  subnet_id      = aws_subnet.subnets[0].id
  route_table_id = aws_route_table.routetables[0].id

  depends_on = [
    aws_route.routes
  ]
}

resource "aws_route_table_association" "associate_private" {
  subnet_id      =  aws_subnet.subnets[1].id
  route_table_id = aws_route_table.routetables[1].id

  depends_on = [
    aws_route_table_association.associate_public
  ]
}


resource "aws_security_group" "forinstances" {
  description = "This is for instances"
  vpc_id      = aws_vpc.loadbalvpc.id 
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" 
  }
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "TCP"
  }

  tags = {
    Name = "security_group_for_instance"
  }

}