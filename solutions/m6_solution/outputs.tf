output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}

# Use AWS provider function to parse ARN
output "vpc_arn_components" {
  description = "Parsed components of VPC ARN using provider-defined function"
  value       = provider::aws::arn_parse(aws_vpc.main.arn)
}

output "lb_public_dns" {
  description = "Public DNS address of the load balancer"
  value       = "http://${aws_lb.web.dns_name}:${var.application_config.load_balancer_port}"
}

output "public_subnet_arns" {
  description = "ARNs of the created public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}

output "bucket_domain_names" {
  description = "Domain names for each bucket created"
  value       = [for bucket in aws_s3_bucket.web : bucket.bucket_domain_name]
}