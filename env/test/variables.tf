##Access key
variable "access_key" {
  description = "Access key"
  type        = string
}

##Secret Key
variable "secret_key" {
  description = "Secret Key"
  type        = string
}

##General Config
variable "general_config" {
  type = map(any)
  default = {
    project = "example"
    env     = "test"
  }
}

##Regions
variable "regions" {
  default = {
    tokyo    = "ap-northeast-1"
    virginia = "us-east-1"
  }
}

##Network
variable "vpc" {
  description = "CIDR BLOCK for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = map(any)
  default = {
    availability_zones = {
      az-1a = {
        az = "ap-northeast-1a"
      },
      az-1c = {
        az = "ap-northeast-1c"
      }
    }
  }
}

variable "public_subnets" {
  type = map(any)
  default = {
    subnets = {
      public-1a = {
        name = "public-1a",
        cidr = "10.0.10.0/24",
        az   = "ap-northeast-1a"
      },
      public-1c = {
        name = "public-1c",
        cidr = "10.0.30.0/24",
        az   = "ap-northeast-1c"
      }
    }
  }
}

variable "dmz_subnets" {
  type = map(any)
  default = {
    subnets = {
      dmz-1a = {
        name = "dmz-1a",
        cidr = "10.0.20.0/24",
        az   = "ap-northeast-1a"
      },
      dmz-1c = {
        name = "dmz-1c",
        cidr = "10.0.40.0/24",
        az   = "ap-northeast-1c"
      }
    }
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    subnets = {
      private-1a = {
        name = "private-1a"
        cidr = "10.0.50.0/24"
        az   = "ap-northeast-1a"
      },
      private-1c = {
        name = "private-1c"
        cidr = "10.0.70.0/24"
        az   = "ap-northeast-1c"
      }
    }
  }
}

##Security Group CIDR
variable "operation_sg_1_cidr" {
  default = ["0.0.0.0/0"]
}

variable "operation_sg_2_cidr" {
  default = ["0.0.0.0/0"]
}

variable "operation_sg_3_cidr" {
  default = ["0.0.0.0/0"]
}

##IAM Account ID
variable "iam_account_id" {
  description = "IAM account id for S3 bucket's principal"
  type        = string
}

variable "zone_id" {
  description = "Zone id on Route53"
  type        = string
  default     = "Z07403921OYE516WPU79B"
}

##ACM
variable "domain_name" {
  description = "Domain name for ACM"
  type        = string
  default     = "onya-lab.site"
}

##SNS
variable "sns_email" {
  description = "email address for sns"
  type        = string
}

variable "sans" {
  description = "Subject alternative names for ACM"
  type        = string
  default     = "*.onya-lab.site"
}

##ECR Image Name
variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "git_codepipeline_approve_terraform"
}

##Docker Image Name
variable "image_name" {
  description = "Dockerimage name"
  type        = string
  default     = "takahiros991/git_codepipeline_approve_terraform"
}

##Fargate CPU
variable "fargate_cpu" {
  description = "fargate cpu"
  type        = string
  default     = "256"
}

##Fargate Memory
variable "fargate_memory" {
  description = "fargate memory"
  type        = string
  default     = "512"
}

##CodeDeploy
variable "codedeploy_app_name" {
  description = "Codedeploy app name"
  type        = string
  default     = "app01"
}

variable "deployment_group_name" {
  description = "Codedeploy deployment group name"
  type        = string
  default     = "app01"
}

##IAM ECS
variable "role_name_1" {
  description = "ECS IAM role name"
  type        = string
  default     = "role-fargate_task_execution"
}

variable "policy_name_1" {
  description = "ECS IAM policy name"
  type        = string
  default     = "fargate_task_execution"
}

##IAM Codebuild
variable "role_name_2" {
  description = "Codebuild IAM role name"
  type        = string
  default     = "role-codebuild-service-role"
}

variable "policy_name_2" {
  description = "Codebuild IAM policy name"
  type        = string
  default     = "build-policy"
}

##IAM Codedeploy
variable "role_name_3" {
  description = "Codedeploy IAM role name"
  type        = string
  default     = "role-codedeploy-service-role"
}

variable "policy_name_3" {
  description = "Codedeploy IAM policy name"
  type        = string
  default     = "deploy-policy"
}

##IAM Codepipeline
variable "role_name_4" {
  description = "Codepipeline IAM role name"
  type        = string
  default     = "role-codepipeline-service-role"
}

variable "policy_name_4" {
  description = "Codepipeline IAM policy name"
  type        = string
  default     = "pipeline-policy"
}

##Codebuild Github URL
variable "github_url" {
  description = "Codebuild Github URL"
  type        = string
  default     = ""
}

##Codepipeline Github Repository ID
variable "full_repositroy_id" {
  description = "Codepipeline Github repository id"
  type        = string
  default     = ""
}

##Codepipeline Github Branch Name
variable "branch_name" {
  description = "Codepipeline Github branch name"
  type        = string
  default     = "main"
}

##Codepipeline Task Definition Tempalte Path
variable "task_definition_template_path" {
  description = "Codepipeline Task Definition Tempalte Path"
  type        = string
  default     = ""
}

##Codepipeline App Spec Tempalte Path
variable "app_spec_template_path" {
  description = "Codepipeline App Spec Tempalte Path"
  type        = string
  default     = ""
}