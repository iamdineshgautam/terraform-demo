# VPC
resource "aws_vpc" "custome_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "custom_vpc"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custome_vpc.id

  tags = {
    Name = "igw"
  }
}

# Public Subnets (we will create 2 subnets coz Load Balancer requires minimum 2 Availability Zones.) 
# Subnet-1
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.custome_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_1"
  }
}

# Subnet-2
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.custome_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_2"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custome_vpc.id
  route = {
    igw = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public_rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group For EC2
resource "aws_security_group" "ec2_sg" {
  name = "EC2-SG"
  vpc_id = aws_vpc.custome_vpc.id

  ingress {
    from_port = var.ssh_port
    to_port = var.ssh_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.http_port
    to_port = var.http_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
# EC2-1
resource "aws_instance" "server-1" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true 

  user_data = file("/root/terraform-b32/day-3-vpc/user-data.sh")

  tags = {
    Name = "server-1"
  }
}

# EC2-2
resource "aws_instance" "server-2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = aws_subnet.public_subnet_2.id
  associate_public_ip_address = true

  user_data = file("/root/terraform-b32/day-3-vpc/user-data.sh")

  tags = {
    Name = "server-2"
  }
}


# Now Security Group for Load Balancer
resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
  vpc_id = aws_vpc.custome_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Target Group 
resource "aws_alb_target_group" "tg" {
  name = "tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.custome_vpc.id
}

# register EC2 instances
# tg-attchment
resource "aws_lb_target_group_attachment" "tg-attachment_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.server-1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "tg-attachment_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.server-2.id
  port = 80
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name = "alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-sg.id]
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
    ]
}

# ALB Listeners
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }

}