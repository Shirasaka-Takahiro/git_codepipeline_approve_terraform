##Provider for ap-northeast-1
provider "aws" {
  profile    = "terraform-user"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-northeast-1"
}

provider "aws" {
  profile    = "terraform-user"
  alias      = "virginia"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

##Network
module "network" {
  source = "../../module/network"

  general_config      = var.general_config
  availability_zones  = var.availability_zones
  vpc_id              = module.network.vpc_id
  vpc_cidr            = var.vpc_cidr
  internet_gateway_id = module.network.internet_gateway_id
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  dmz_subnets         = var.dmz_subnets
  public_subnet_ids   = module.network.public_subnet_ids
}

##Security Group Internal
module "internal_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_blocks    = ["10.0.0.0/16"]
  sg_role        = "internal"
}

##Secutiry Group Operation
module "operation_sg_1" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_1_cidr
  sg_role        = "operation_1"
}

module "operation_sg_2" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_2_cidr
  sg_role        = "operation_2"
}

module "operation_sg_3" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_3_cidr
  sg_role        = "operation_3"
}

module "alb_http_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "alb_http"
}

module "alb_https_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  cidr_blocks    = ["0.0.0.0/0"]
  sg_role        = "alb_https"
}

##ALB
module "alb" {
  source = "../../module/alb"

  vpc_id                   = module.network.vpc_id
  general_config           = var.general_config
  public_subnet_ids        = module.network.public_subnet_ids
  alb_http_sg_id           = module.alb_http_sg.security_group_id
  alb_https_sg_id          = module.alb_https_sg.security_group_id
  cert_alb_arn             = module.acm_alb.cert_alb_arn
  alb_access_log_bucket_id = module.s3_alb_access_log.bucket_id
}

##S3
module "s3_alb_access_log" {
  source = "../../module/s3"

  general_config = var.general_config
  bucket_role    = "alb-access-log"
  iam_account_id = var.iam_account_id
}

module "s3_pipeline_bucket" {
  source = "../../module/s3"

  general_config = var.general_config
  bucket_role    = "code-pipeline"
  iam_account_id = var.iam_account_id
}

##DNS
module "naked_domain" {
  source = "../../module/route53"

  zone_id      = var.zone_id
  zone_name    = "onya-lab.site"
  record_type  = "A"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "www" {
  source = "../../module/route53"

  zone_id      = var.zone_id
  zone_name    = "www.onya-lab.site"
  record_type  = "A"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "stg" {
  source = "../../module/route53"

  zone_id      = var.zone_id
  zone_name    = "stg.onya-lab.site"
  record_type  = "A"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

##ACM
module "acm_alb" {
  source = "../../module/acm"

  zone_id     = var.zone_id
  domain_name = var.domain_name
  sans        = var.sans
}

##SNS
module "sns" {
  source = "../../module/sns"

  general_config = var.general_config
  sns_email      = var.sns_email
}

##CloudWatch
module "cloudwatch" {
  source         = "../../module/cloudwatch"
  general_config = var.general_config
}

##ECS
module "ecs" {
  source = "../../module/ecs"

  general_config            = var.general_config
  tg_blue_arn               = module.alb.tg_blue_arn
  ecr_repository            = module.ecr.ecr_repository
  cloudwatch_log_group_name = module.cloudwatch.cloudwatch_log_group_name
  fargate_cpu               = var.fargate_cpu
  fargate_memory            = var.fargate_memory
  dmz_subnet_ids            = module.network.dmz_subnet_ids
  internal_sg_id            = module.internal_sg.security_group_id
  iam_ecs_arn               = module.iam_ecs.iam_role_arn
}

##ECR
module "ecr" {
  source = "../../module/ecr"

  regions         = var.regions
  repository_name = var.repository_name
  image_name      = var.image_name
}

##Codebuild
module "codebuild" {
  source = "../../module/codebuild"

  general_config    = var.general_config
  regions           = var.regions
  iam_codebuild_arn = module.iam_codebuild.iam_role_arn
  github_url        = var.github_url
  vpc_id            = module.network.vpc_id
  dmz_subnet_ids    = module.network.dmz_subnet_ids
  internal_sg_id    = module.internal_sg.security_group_id
}

##CodeDeploy
module "codedeploy" {
  source = "../../module/codedeploy"

  general_config        = var.general_config
  codedeploy_app_name   = var.codedeploy_app_name
  deployment_group_name = var.deployment_group_name
  iam_codedeploy_arn    = module.iam_codedeploy.iam_role_arn
  ecs_cluster_name      = module.ecs.ecs_cluster_name
  ecs_service_name      = module.ecs.ecs_service_name
  tg_blue_name          = module.alb.tg_blue_name
  tg_green_name         = module.alb.tg_green_name
  alb_https_listener    = module.alb.alb_https_listener_arn
}

##IAM
module "iam_ecs" {
  source = "../../module/iam"

  role_name   = var.role_name_1
  policy_name = var.policy_name_1
  role_json   = file("../../module/iam/roles_json/fargate_task_assume_role.json")
  policy_json = file("../../module/iam/policy_json/task_execution_policy.json")
}

module "iam_codebuild" {
  source = "../../module/iam"

  role_name   = var.role_name_2
  policy_name = var.policy_name_2
  role_json   = file("../../module/iam/roles_json/codebuild_assume_role.json")
  policy_json = file("../../module/iam/policy_json/codebuild_build_policy.json")
}

module "iam_codedeploy" {
  source = "../../module/iam"

  role_name   = var.role_name_3
  policy_name = var.policy_name_3
  role_json   = file("../../module/iam/roles_json/codedeploy_assume_role.json")
  policy_json = file("../../module/iam/policy_json/codedeploy_deploy_policy.json")
}

module "iam_codepipeline" {
  source = "../../module/iam"

  role_name   = var.role_name_4
  policy_name = var.policy_name_4
  role_json   = file("../../module/iam/roles_json/codepipeline_assume_role.json")
  policy_json = file("../../module/iam/policy_json/codepipeline_pipeline_policy.json")
}

##Codestarconnections
module "codestarconnections" {
  source = "../../module/codestarconnections"

  general_config = var.general_config
}

##Codepipeline
module "codepipeline" {
  source = "../../module/codepipeline"

  general_config                     = var.general_config
  iam_codepipeline_arn               = module.iam_codepipeline.iam_role_arn
  bucket_name                        = module.s3_pipeline_bucket.bucket_name
  branch_name                        = var.branch_name
  full_repositroy_id                 = var.full_repositroy_id
  codebuild_project_name             = module.codebuild.codebuild_project_name
  codedeploy_app_name                = module.codedeploy.codedeploy_app_name
  codedeploy_deployment_group_name   = module.codedeploy.codedeploy_deployment_group_name
  codestarconnections_connection_arn = module.codestarconnections.codestarconnections_connection_arn
}

