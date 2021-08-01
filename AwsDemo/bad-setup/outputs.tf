###############################################################################
# Outputs - Security Groups
###############################################################################
output "all_sg_id" {
  description = "The ID of the ALL Security Group."
  value       = aws_security_group.all_security_group.id
}

###############################################################################
# Outputs - ALB
###############################################################################
output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.dns_name
}
