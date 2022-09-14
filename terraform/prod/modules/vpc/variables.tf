
variable vpc_name {
    type        = string
    description = "vpc name"
}

variable eks_cluster_name {
    description = "eks cluster name"
    type        = string
}

variable cidr_block {
    type        = string
    description = "vpc cidr block"
}

variable enable_nat_gateway {
    type        = bool
    description = "want a nat gateway?"
    default     = true
}

variable single_nat_gateway {
    type        = bool
    description = "want a single nat gateway?"
    default     = false
}

variable myip {
    description = "whitelisted"
    type        = list(string)
}