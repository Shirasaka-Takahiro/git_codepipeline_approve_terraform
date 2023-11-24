variable "general_config" {
  type = map(any)
}
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "iam_ecs_arn" {}
variable "tg_blue_arn" {}
variable "ecr_repository" {}
#variable "cloudwatch_log_group_name" {}
variable "dmz_subnet_ids" {}
variable "internal_sg_id" {}