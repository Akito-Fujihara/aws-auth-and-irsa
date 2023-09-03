module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_endpoint_public_access = true

  cluster_name    = "eks-aws-infra-and-irsa"
  cluster_version = "1.26"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    main = {
      desired_size   = 1
      instance_types = ["t2.micro"]
      iam_role_additional_policies = {
        s3_access_role = aws_iam_policy.node_role_access.arn
      }
    }
  }

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = var.userarn
      username = var.username
      groups   = ["system:masters"]
    },
  ]

  node_security_group_additional_rules = {
    # AdmissionWebhookが動作しないので追加指定
    admission_webhook = {
      description                   = "Admission Webhook"
      protocol                      = "tcp"
      from_port                     = 0
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
    # Node間通信を許可
    ingress_node_communications = {
      description = "Ingress Node to node"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      self        = true
    }
    egress_node_communications = {
      description = "Egress Node to node"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "egress"
      self        = true
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "s3_irsa_access" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.30.0"

  role_name = "s3-irsa-access"
  allow_self_assume_role = false

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "default:s3-irsa-access",
      ]
    }
  }
  role_policy_arns = {
    s3 = aws_iam_policy.irsa_access.arn
  }
}
