# get my DSL public IP
data "http" "myip" {
  url       = "https://ipv4.icanhazip.com"
}

# generate a random string 
resource "random_string" "suffix" {
  length    = 8
  special   = false
}

/*
cluster_name        = EKS cluster name
*/
locals {
  cluster_name      = "eks-${random_string.suffix.result}"
}

module "vpc" {
  source   = "./modules/vpc"

  vpc_name              = "eks"
  cidr_block            = "10.201.0.0/16"
  enable_nat_gateway    = true
  single_nat_gateway    = true
  eks_cluster_name      = "prod"
  myip                    = ["${chomp(data.http.myip.body)}/32"]
}

module "eks" {
 source   = "./modules/eks"
 eks_cluster_name        = "eks-${random_string.suffix.result}"
 vpc_id                  = module.vpc.vpc_id
 availability_zones      = module.vpc.availability_zones
 eks_cluster_version     = "1.23"
 eks_public_subnet_ids   = module.vpc.eks_public_subnet_ids
 eks_private_subnet_ids  = module.vpc.eks_private_subnet_ids
 desired_capacity        = 3
 min_capacity            = 1
 max_capacity            = 3
 max_unavailable         = 1
 instance_type           = ["t2.micro"]
 ami_type                = "AL2_x86_64"
 capacity_type           = "ON_DEMAND"
 disk_size               = 8
 eks_ssh_public_key      = file("~/.ssh/id_rsa.pub")
}