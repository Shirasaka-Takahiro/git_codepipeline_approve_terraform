output "codedeploy_app_name" {
  value = aws_codedeploy_app.default.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.default.deployment_group_name
}