output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "control_plane_private_ip" {
  value = aws_instance.control_plane.private_ip
}

output "worker_private_ips" {
  value = aws_instance.workers[*].private_ip
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
