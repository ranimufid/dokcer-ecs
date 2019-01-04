provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state_storage_s3_jenkins_pipeline" {
  bucket = "terraform-remote-state-storage-s3-jenkins-pipeline"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "S3 Remote Terraform State Store"
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-remote-state-storage-s3-jenkins-pipeline"
    region  = "eu-central-1"
    key     = "dokcer-ecs"
  }
}
