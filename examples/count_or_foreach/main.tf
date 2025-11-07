provider "aws" {
 region = "us-east-1"
}

locals {
  bucket_list = ["logs","data","backups"]
}

resource "aws_s3_bucket" "use_count" {
  count = length(local.bucket_list)
  bucket_prefix = local.bucket_list[count.index]
}

#resource "aws_s3_bucket" "use_foreach" {
#  for_each = toset(local.bucket_list)
#  bucket_prefix   = each.value
#}