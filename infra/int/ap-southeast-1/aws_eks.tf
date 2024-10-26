module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "20.8.5"
  cluster_name                             = "bodhi-int-eks"
  cluster_version                          = "1.29"
  cluster_endpoint_private_access          = false
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    k8s-core = {
      name           = "k8s-core"
      min_size       = 1
      max_size       = 10
      desired_size   = 2
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
      subnet_ids     = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
      tags = {
        "k8s.io/cluster-autoscaler/bodhi-int-eks" = "owned"
        "k8s.io/cluster-autoscaler/enabled"           = "TRUE"
      }
      labels = {
        "nodegroup" = "k8s-core"
      }
    }

    int =  {
      name           = "int"
      min_size       = 1
      max_size       = 10
      desired_size   = 2
      instance_types = ["t3a.medium"]
      capacity_type  = "ON_DEMAND"
      subnet_ids     = [module.vpc.private_subnets[3],module.vpc.private_subnets[4],module.vpc.private_subnets[5]]
      tags = {
        "k8s.io/cluster-autoscaler/bodhi-int-eks" = "owned"
        "k8s.io/cluster-autoscaler/enabled"           = "TRUE"
      }
      labels = {
        "nodegroup" = "int"
      }
    }
  }

  node_security_group_additional_rules = {
    postgresql_service_ingress_rule_1 = {
      description                   = "pg ingress 1"
      protocol                      = "TCP"
      from_port                     = 15232
      to_port                       = 15232
      type                          = "ingress"
      source_cluster_security_group = true
    }

    postgresql_service_ingress_rule_2 = {
      description                   = "pg ingress 2"
      protocol                      = "TCP"
      from_port                     = 30970
      to_port                       = 30970
      type                          = "ingress"
      source_cluster_security_group = true
    }

    prometheus_service_ingress_rule = {
      description                   = "prometheus ingress"
      protocol                      = "TCP"
      from_port                     = 9090
      to_port                       = 9090
      type                          = "ingress"
      source_cluster_security_group = true
    }

    node_exporter_ingress_rule = {
      description                   = "node exporter ingress"
      protocol                      = "TCP"
      from_port                     = 9100
      to_port                       = 9100
      type                          = "ingress"
      source_cluster_security_group = true
    }

    olm_package_server_ingress_rule = {
      description                   = "olm package server ingress"
      protocol                      = "TCP"
      from_port                     = 5443
      to_port                       = 5443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.39.0"
  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-ap-east-1-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}
