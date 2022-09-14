
output vpc_id {
    value       = module.vpc.vpc_id
    description = "vpc id"
}

output availability_zones {
    value = [ for zone in local.sorted_zones : zone ]
    description = "list of availability zones"
}

output eks_private_subnet_ids {
    value       = module.vpc.private_subnets
    description = "list of IDs of private subnets"
}

output eks_public_subnet_ids {
    value       = module.vpc.public_subnets
    description = "list of IDs of public subnets"
}