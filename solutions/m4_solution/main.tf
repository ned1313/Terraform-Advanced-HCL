provider "aws" {
  region = var.aws_region
}

# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Local values for common tags
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = var.team
    Owner       = coalesce(var.owner, var.team)
  }
  name_prefix = lower(format("%s-%s", var.team, var.environment))

  ingress_rules = [
    {
      from_port   = var.environment == "production" ? 8080 : 80
      to_port     = var.environment == "production" ? 8080 : 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = var.environment == "production" ? 8443 : 443
      to_port     = var.environment == "production" ? 8443 : 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  buckets = ["logs", "app-data", "backups"]

  bucket_prefixes = concat(local.buckets, var.additional_buckets)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = format("%s-vpc", local.name_prefix)
  })
}

resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = format("%s-public-%s", local.name_prefix, (count.index + 1))
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = format("%s-igw", local.name_prefix)
  })

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = format("%s-rtb", local.name_prefix)
  })
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_s3_bucket" "web" {
  for_each = toset(local.bucket_prefixes)

  bucket_prefix = format("%s-%s-", local.name_prefix, each.value)
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "web" {
  for_each = toset(local.bucket_prefixes)
  bucket   = aws_s3_bucket.web[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}