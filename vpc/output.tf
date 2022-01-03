output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "instance_public_ip" {
  description = "Instance public ip"
  value       = { for key in keys(var.instances) : key => aws_eip.lb[key].public_ip }
}

output "tags_all_lookup_fun" {
  description = "lookup function"
  value       = lookup(var.instance_tags, "web_server")
}

output "security_group_ids" {
  description = "security group ids"
  value       = concat([aws_security_group.allow_tls.id, aws_security_group.allow_ssh.id])
}
