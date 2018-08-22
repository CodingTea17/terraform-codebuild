variable "aws_region" {}
variable "account_id" {}
variable "repo_url" {}


provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_ecr_repository" "go-http" {
  name = "go-mini-http"
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  role        = "${aws_iam_role.example.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "example" {
  name         = "next-test-project"
  description  = "nexT_test_codebuild_project"
  build_timeout      = "5"
  service_role = "${aws_iam_role.example.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:17.09.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${var.aws_region}"
    }

    environment_variable {
      "name"  = "IMAGE_REPO_NAME"
      "value" = "${aws_ecr_repository.go-http.name}"
    }

    environment_variable {
      "name"  = "AWS_ACCOUNT_ID"
      "value" = "${var.account_id}"
    }
  }

  source {
    type            = "GITHUB"
    location        = "${var.repo_url}"
    git_clone_depth = 1
  }
}