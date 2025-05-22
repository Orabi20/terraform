output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  description = "Security group ID for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}
