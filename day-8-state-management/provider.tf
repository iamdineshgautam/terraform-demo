provider "aws" {
  region = "ap-south-1"
  profile = "dev"
}

terraform {
  backend "s3" {
    bucket = "deploywithdinesh.space"
    region = "ap-south-1"
    key = "terraform.tfstate"
    profile = "dev"
    use_lockfile = true
    shared_config_files = [ "/root/.aws/credentials" ]
  }
}