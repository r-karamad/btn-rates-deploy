# get all the alive availability zones in the region 
data "aws_availability_zones" "available" {
  state     = "available"
}

locals  {
  sorted_zones            = sort(data.aws_availability_zones.available.names)
  eks_public_cidr_block   = cidrsubnet(var.cidr_block, 4, 2)
  eks_private_cidr_block  = cidrsubnet(var.cidr_block, 4, 1)
  availability_zones      = [ for zone in local.sorted_zones : zone ]
  eks_public_subnet_spec  = { for index, zone in local.sorted_zones : zone => cidrsubnet(local.eks_public_cidr_block, 2, index) }
  eks_private_subnet_spec = { for index, zone in local.sorted_zones : zone => cidrsubnet(local.eks_private_cidr_block, 2, index) }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" 

  version               = "~> 3.0" 
  name                  = var.vpc_name
  cidr                  = var.cidr_block
  azs                   = local.availability_zones
  private_subnets       = values(local.eks_private_subnet_spec)
  public_subnets        = values(local.eks_public_subnet_spec)

  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = var.single_nat_gateway
  enable_dns_hostnames  = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}"   = "shared" 
    "kubernetes.io/role/elb"                          = 1  
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}"   = "shared"
    "kubernetes.io/role/internal-elb"                 = 1 
  }
}

