##Codebuild Project
resource "aws_codebuild_project" "project" {
  name         = "${var.general_config["project"]}-${var.general_config["env"]}-project"
  description  = "cicd-project"
  service_role = var.iam_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.regions["tokyo"]
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "ECS_CICD"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type            = "CODEPIPELINE"
    location        = var.github_url
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  vpc_config {
    vpc_id  = var.vpc_id
    subnets = var.dmz_subnet_ids
    security_group_ids = [
      var.internal_sg_id
    ]
  }
}