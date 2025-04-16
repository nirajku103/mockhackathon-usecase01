# OIDC Provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "74f3a68f16524f15424927704c9506f55a9316bd" # GitHub's OIDC thumbprint
  ]
}

# IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:nirajku103/mockhackathon-usecase01:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}



# Attach Policies to the IAM Role
resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Adjust this to least privilege
}





module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  alb_target_group_arns = module.alb.target_group_arns
  ami = var.ec2_ami
  instance_type = var.ec2_instance_type
}
