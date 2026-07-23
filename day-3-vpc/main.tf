# Custom VPC with CIDR 10.0.0.0/16
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

# public subnet with CIDR 10.0.0.0/24
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public_az
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# private subnet with  CIDR 10.0.1.0/24
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.private_az
  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway with custom vpc
resource "aws_internet_gateway" "IGW" {
  vpc_id =  aws_vpc.my-vpc.id
  tags = {
    Name = "IGW"
  }
}

# Now we have to create nat-gw but for nate gw we need elastic ip 
# so first we need to create Elastic IP then nat-gw

#NAT Elastic IP
resource "aws_eip" "nat_eip" {
  domain = aws_vpc.my-vpc.id
  tags = {
    Name = "nat_eip"
  }
}

# Now We will create NAT-Gateway For Custom VPC
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Name = "nat_gateway"
  }
}

# Route Tables
#1.  Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    gateway_id = aws_internet_gateway.IGW.id
    cidr_block = "0.0.0.0/0"
  }
}

    # public route table association
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 2. Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

    # private route table association
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group
resource "aws_security_group" "my-sg" {
  name = "my-security-group-vpc"
  description = "my-security-group-vpc"
  vpc_id = aws_vpc.my-vpc.id

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
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group-vpc"
  }
}

# Now We will create Instances
# Public Instance

resource "aws_instance" "public_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  user_data = file("/root/terraform-demo/day-3-vpc/user-data.sh")

  tags = {
    Name = "public-instance"
  }
}

# private instance

resource "aws_instance" "private_instance" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id = aws_subnet.private_subnet.id
  user_data = file("/root/terraform-demo/day-3-vpc/user-data.sh")

  tags = {
    Name = "private-instance"
  }
}
