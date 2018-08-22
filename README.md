# Terraform CodeBuild (IAC CI Project)
A Terraform CI project that creates an AWS ECR and CodeBuild Project. The project builds a dockerimage from a speciifed code repositoy that contains a valid Dockerfile and accompanying buildspec.yml.

# Requirements
1) Terraform installed
2) awscli installed and configured
3) A var file that contains valid values for:
    - aws_region (e.g. us-west-2)
    - account_id (AWS account id)
    - repo_url (source code url e.g. GitHub, CodeCommit, GitLab)

# How To
1) `terraform init`
2) `terraform apply -var-file="terraform.tfvars"` (where "terraform.tfvars" is the arbitrary name of my vars file)
3) Be amazed!

# Future ToDo
1) Template out more values (e.g. CodeBuild project name, IAM user, and ECR name)
2) Setup up second stage for freshly built images, the CD! Eventually it will deploy the dockerimage to an EC2, which will also be defined as IAC.