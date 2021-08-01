###############################################################################
# Variables - Environment
###############################################################################
variable "region" {
  description = "The AWS region the state should reside in."
  type        = string
  default     = "ap-southeast-2"
}

###############################################################################
# Variables - VPC
###############################################################################
variable "vpc_name" {
  description = "VPC Name"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false."
  type        = bool
  default     = false
}

variable "public_cidr_a" {
  description = "Public CIDR block A."
}

variable "public_cidr_b" {
  description = "Public CIDR block B."
}

variable "private_cidr_a" {
  description = "Private CIDR block A."
}

variable "private_cidr_b" {
  description = "Private CIDR block B."
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

###############################################################################
# Variables - Security Group
###############################################################################
variable "source_address" {
  description = "(Optional) The address to allow to communicate with ALB."
  default     = "0.0.0.0/0"
}

###############################################################################
# Variables - SSL
###############################################################################
variable "domain" {
  description = "The domain name to be put in the certificate registration."
  type        = string
  default     = "example"
}

###############################################################################
# Variables - EC2
###############################################################################
variable "ec2_name" {
  description = "Name to be used on all EC2 resources"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "min_size" {
  description = "The minimum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the autoscaling group"
  type        = number
  default     = 1
}

###############################################################################
# Variables - Elasticache
###############################################################################
variable "elasticache_name" {
  description = "Name of Elasticache Redis Instance"
  type        = string
}

###############################################################################
# Variables - S3 Buckets
###############################################################################
variable "bucket_name" {
  description = "Prefix name of the S3 bucket"
  type        = string
}
