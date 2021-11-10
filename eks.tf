provider "aws" {
  region = local.region
}

#########  Supporting rresources

locals {
  name            = "complete-${random_string.suffix.result}"
  cluster_version = "1.20"
  region          = "us-east-1"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


############

data "aws_availability_zones" "available" {
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~>3.0"

    name = local.name
    cidr = "10.0.0.0/16"
    azs = data.aws_availability_zones.available.names
    private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    enable_nat_gateway   = true
    enable_dns_hostnames = true

    public_subnet_tags = {
        "kubernetes.io/cluster/${local.name}" = "shared"
        "kubernetes.io/role/elb"              = "1"
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/${local.name}" = "shared"
        "kubernetes.io/role/internal-elb"     = "1"
    }

  tags = {
    Name    = local.name
    Env = "dev"
  }

}