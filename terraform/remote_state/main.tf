provider "aws" {
  region  = "us-west-2"
}

# Read the state file from the root to get the prefix variable
data "terraform_remote_state" "root_state" {
  backend = "s3"

  config = {
    bucket         = "brendanbeckcom-remote-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "${data.terraform_remote_state.root_state.outputs.prefix}-remote-state"
  # acl    = "authenticated-read"

  tags = {
    Name        = "${data.terraform_remote_state.root_state.outputs.prefix}-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state" {
  bucket = aws_s3_bucket.remote_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name          = "${data.terraform_remote_state.root_state.outputs.prefix}-remote-state-lock"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "LockID"
  attribute {
    name        = "LockID"
    type        = "S"
  }
  tags = {
    Name        = "${data.terraform_remote_state.root_state.outputs.prefix}-remote-state-lock"
  }
}
