# Terraform state management is the practice of storing, securing, and maintaining Terraform's state file (terraform.tfstate), 
# which maps the resources in your configuration to the actual infrastructure that exists in your cloud or datacenter. 
# Terraform uses this state to determine what needs to be created, updated, or destroyed during each plan and apply.

provider "aws" {
  region = "ap-south-1"
  profile = "dev"
}

terraform {
  backend "s3" {
    bucket = "deploywithdinesh.space"
    region = "ap-south-1"
    key = "terraform.tfstate"   #The path/name of the state file inside S3.
    profile = "dev"
    use_lockfile = true
    shared_config_files = [ "/root/.aws/credentials" ]
  }
}