##SNS Topic
resource "aws_sns_topic" "default_topic" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-topic"
}

##SNS SUbscription
resource "aws_sns_topic_subscription" "sns_default_topic_subscription" {
  topic_arn = aws_sns_topic.default_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}