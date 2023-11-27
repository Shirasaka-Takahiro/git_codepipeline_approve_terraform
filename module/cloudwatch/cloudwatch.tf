##Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "deafult" {
  name              = "/${var.general_config["project"]}/${var.general_config["env"]}/web01"
  retention_in_days = 30
}