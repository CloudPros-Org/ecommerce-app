module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_capacity
      instance_types = var.instance_types
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = { Project = var.cluster_name }
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = module.eks.kubeconfig
}

output "cluster_name" { value = module.eks.cluster_name }
output "kubeconfig_path" { value = local_file.kubeconfig.filename }
