variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "The subnets for the EC2 instances"
  type        = list(string)
}

variable "alb_target_group_arns" {
  description = "The ARNs of the ALB target groups"
  type        = list(string)
}

variable "ami" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
}