module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "terraform-managed-eks-vpc"
  version                = "5.8.1"
  cidr                   = "10.0.0.0/16"
  secondary_cidr_blocks  = ["10.32.0.0/16"]
  azs                    = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.32.0.0/18", "10.32.64.0/18", "10.32.128.0/18"]
  public_subnets         = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24", "10.32.192.0/24", "10.32.193.0/24", "10.32.194.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  map_public_ip_on_launch= true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    terraform-managed = true
    environment       = "int"
  }

}
