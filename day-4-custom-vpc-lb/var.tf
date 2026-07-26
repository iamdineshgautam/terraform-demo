variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro" 
}

variable "ami_id" {
  default = "ami-09d88f7c4c272b0c5"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.1.0/24"
}

variable "http_port" {
    default = 80
}

variable "ssh_port" {
    default = 22 
}

variable "key_name" {
    default = "u3-key"
}
