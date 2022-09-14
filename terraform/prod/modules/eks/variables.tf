variable vpc_id {
    description = "VPC ID"
    type        = string
}

variable availability_zones {
    description = "Availability Zones"
    type        = list(string)
}

variable eks_cluster_name {
    description = "The EKS cluster name"
    type        = string
}

variable eks_cluster_version {
    description = "The EKS cluster version"
    type        = string
}
variable eks_private_subnet_ids {
    description = "EKS cluster private subnet IDs and AZs"
    type        = list(string)
}

variable eks_public_subnet_ids {
    description = "EKS cluster public subnet IDs and AZs"
    type        = list(string)
}
variable tags {
    description = "General Tags for EKS resources"
    type        = map
    default     = {
        "terraform" = "true"
    }
}
variable desired_capacity {
    description = "The Worker nodes desired capacity"
    type        = number
}

variable min_capacity {
    description = "The Worker nodes minimum capacity"
    type        = number
}

variable max_capacity {
    description = "The Worker nodes maximum capacity"
    type        = number
}
variable instance_type {
    description = "The Worker nodes EC2 instance type"
    type        = list(string)
}
variable max_unavailable {
    description = "Desired max number of unavailable worker nodes during node group update"
    type        = number
}
variable ami_type {
    description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the AWS documentation for valid values. Terraform will only perform drift detection if a configuration value is provided."
    type        = string
}
variable capacity_type {
    description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT. Terraform will only perform drift detection if a configuration value is provided."
    type        = string
}
variable disk_size {
    description = "Disk size in GiB for worker nodes. Defaults to 20. Terraform will only perform drift detection if a configuration value is provided"
    type        = number
}

variable eks_ssh_public_key {
    description = "Deployer ssh public key"
    type        = string
}