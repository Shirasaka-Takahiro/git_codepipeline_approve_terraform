##Codestar Connections Connection
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.general_config["project"]}-github-connection"
  provider_type = "GitHub"
}