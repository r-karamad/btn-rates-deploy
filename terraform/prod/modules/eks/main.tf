
resource "aws_eks_cluster" "prod" {
  name            = var.eks_cluster_name
  version         = var.eks_cluster_version
  role_arn        = aws_iam_role.eks.arn
  vpc_config {
    subnet_ids    = concat(var.eks_private_subnet_ids, var.eks_public_subnet_ids)
  }
  depends_on      = [ 
        aws_iam_role_policy_attachment.eks_iam_policy_attachment,
        aws_iam_role_policy_attachment.eks_iam-AmazonEKSVPCResourceController,
  ]

  tags = {
      Name = var.eks_cluster_name
      }
}

resource "aws_iam_role" "eks" {
  name                = "eks"
  assume_role_policy  = jsonencode({
    
    Version     = "2012-10-17",
    Statement   = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_iam_role_policy_attachment" "eks_iam_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}
resource "aws_iam_role_policy_attachment" "eks_iam-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_node_group" "prod" {
  cluster_name    = aws_eks_cluster.prod.name
  node_group_name = "prod"
  node_role_arn   = aws_iam_role.prod.arn
  subnet_ids      = var.eks_private_subnet_ids
  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  instance_types  = var.instance_type
  disk_size       = var.disk_size
 
  remote_access {
    ec2_ssh_key = aws_key_pair.prod.key_name
  }

  scaling_config {
    min_size     = var.min_capacity
    max_size     = var.max_capacity
    desired_size = var.desired_capacity
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.policy-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.policy-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.policy-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource aws_key_pair prod {
  key_name   = "eks-prod"
  public_key = var.eks_ssh_public_key
}

resource "aws_iam_role" "prod" {
  name = "eks-node-group-iam-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "policy-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.prod.name
}

resource "aws_iam_role_policy_attachment" "policy-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.prod.name
}

resource "aws_iam_role_policy_attachment" "policy-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.prod.name
}