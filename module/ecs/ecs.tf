##Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-cluster-fargate-web01"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

##Task Definition
resource "aws_ecs_task_definition" "task" {
  family = "${var.general_config["project"]}-${var.general_config["env"]}-task-fargate-web01"
  container_definitions = templatefile("${path.module}/tasks/container_definitions.json",
    {
      ecr_repository_url = var.ecr_repository,
      #cw_log_group       = var.cloudwatch_log_group_name,
      project = var.general_config["project"],
      env     = var.general_config["env"]
    }
  )
  cpu                = var.fargate_cpu
  memory             = var.fargate_memory
  network_mode       = "awsvpc"
  execution_role_arn = var.iam_ecs_arn

  requires_compatibilities = [
    "FARGATE"
  ]
}

##Service
resource "aws_ecs_service" "service" {
  name             = "service-fargate-web01"
  cluster          = aws_ecs_cluster.cluster.arn
  task_definition  = aws_ecs_task_definition.task.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = var.tg_blue_arn
    container_name   = "${var.general_config["project"]}-${var.general_config["env"]}-web01"
    container_port   = "80"
  }

  network_configuration {
    subnets = var.dmz_subnet_ids
    security_groups = [
      var.internal_sg_id
    ]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}