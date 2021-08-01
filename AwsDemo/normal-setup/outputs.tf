###############################################################################
# Outputs - VPC
###############################################################################
output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [aws_subnet.privatesubneta.id, aws_subnet.privatesubnetb.id]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [aws_subnet.publicsubneta.id, aws_subnet.publicsubnetb.id]
}

###############################################################################
# Outputs - Security Groups
###############################################################################
output "alb_sg_id" {
  description = "The ID of the ALB Security Group."
  value       = aws_security_group.alb_security_group.id
}

output "ec2_sg_id" {
  description = "The ID of the EC2 Security Group."
  value       = aws_security_group.ec2_security_group.id
}

output "elasticache_sg_id" {
  description = "The ID of the Redis Security Group."
  value       = aws_security_group.elasticache_security_group.id
}

###############################################################################
# Outputs - SSL
###############################################################################
output "ssl_domain_name" {
  description = "The domain name for which the certificate is issued."
  value       = aws_acm_certificate.self.domain_name
}

###############################################################################
# Outputs - ALB
###############################################################################
output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.dns_name
}
