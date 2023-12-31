terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "356960567614-us-west-2-remote-state"
    encrypt        = true
    dynamodb_table = "356960567614-us-west-2-remote-state-lock"
    key            = "bbcom/static-files.tfstate"
    region         = "us-west-2"
  }
}
provider "aws" {
  region = "us-west-2"
}

variable "prefix" {
  default = "brendanbeckcom"
}



resource "aws_s3_bucket" "static_files" {
  bucket        = "${var.prefix}-static-files"
  force_destroy = true
}

#resource "aws_s3_bucket_acl" "static_files" {
#  bucket     = aws_s3_bucket.static_files.id
#  acl        = "public-read"
#  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
#}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_files.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.static_files]
}

resource "aws_s3_bucket_public_access_block" "static_files" {
  bucket = aws_s3_bucket.static_files.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  # setting this true makes the bucket not public accessable, but cant download using URL
  restrict_public_buckets = false
}


# NOTE: For some reason, I have to run terraform apply twice.
# The first time, it creates everything except this bucket policy, giving an
# 'api error AccessDenied: Access Denied'
# Then running it the second time it works.
resource "aws_s3_bucket_policy" "static-files" {
  bucket = aws_s3_bucket.static_files.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          #"s3:GetObject",
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          #"arn:aws:s3:::${resource.aws_s3_bucket.static_files.bucket}",
          "arn:aws:s3:::${resource.aws_s3_bucket.static_files.bucket}/*"
        ]
      },
    ]
  })
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}









#data "aws_iam_policy_document" "allow_download" {
#  statement {
#    actions   = ["s3:GetObject"]
#    principals {
#      type        = "*"
#      identifiers = ["*"]
#    }
#  }
#}
#
#resource "aws_s3_bucket_policy" "allow_download" {
#  bucket = aws_s3_bucket.static_files.id
#  policy = data.aws_iam_policy_document.allow_download.json
#}



#resource "aws_s3_bucket_ownership_controls" "static_files" {
#  bucket = aws_s3_bucket.static_files.id
#  rule {
#    object_ownership = "BucketOwnerPreferred"
#  }
#}
#
#resource "aws_s3_bucket_public_access_block" "static_files" {
#  bucket = aws_s3_bucket.static_files.id
#
#  block_public_acls       = false
#  block_public_policy     = false
#  ignore_public_acls      = false
#  restrict_public_buckets = false
#}
#
#resource "aws_s3_bucket_acl" "static_files" {
#  depends_on = [
#    aws_s3_bucket_ownership_controls.static_files,
#    aws_s3_bucket_public_access_block.static_files,
#]
#
#  bucket = aws_s3_bucket.static_files.id
#  acl    = "public-read"
#}
