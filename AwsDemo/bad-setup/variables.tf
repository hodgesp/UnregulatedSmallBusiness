###############################################################################
# Variables - Environment
###############################################################################
variable "region" {
  description = "The AWS region the state should reside in."
  type        = string
  default     = "ap-southeast-2"
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
  description = "Name of Elasticache Redis Instance"
  type        = string
}
