variable "ami" {
  default = "ami-01a00762f46d584a1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "u3-key"
}

variable "sg_id" {
  default = "sg-0bf966ee2780cb6fd"
}

variable "volume_size" {
  default = 8
}

variable "volume_type" {
  default = "gp3"
}

variable "tags" {
  type = map(string)
  default = {
    "name" = "webserver"
  }
}