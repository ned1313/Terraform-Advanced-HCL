variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "company" {
  description = "Name of the company"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., development, staging, production)"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = null
}

variable "team" {
  description = "Team responsible for the resources"
  type        = string
  default     = "Platform"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
}

variable "additional_buckets" {
  description = "Additional S3 buckets to create."
  type        = list(string)
}

variable "application_config" {
  description = "Configuration information for the application"
  type = object({
    instance_count         = number
    instance_type          = optional(string, "t3.micro")
    instance_port          = number
    instance_protocol      = string
    load_balancer_port     = number
    load_balancer_protocol = string
    monitoring             = optional(bool)
    health_check = object({
      path     = string
      port     = number
      protocol = string
    })
  })
}
