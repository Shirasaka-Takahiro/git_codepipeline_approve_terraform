##IAM Role
resource "aws_iam_role" "default" {
  name = var.role_name
  #assume_role_policy = file("${path.module}/ecs_json/fargate_task_assume_role.json")
  assume_role_policy = var.role_json
}

##IAM Role Policy
resource "aws_iam_role_policy" "default" {
  name = var.policy_name
  role = aws_iam_role.default.name
  #policy = file("${path.module}/ecs_json/task_execution_policy.json")
  policy = var.policy_json
}