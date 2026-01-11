output "control_plane_ip" {
  description = "Public IP address of the Kubernetes control plane"
  value       = aws_instance.control_plane.public_ip
}

output "worker_ips" {
  description = "Public IP addresses of Kubernetes worker nodes"
  value       = aws_instance.workers[*].public_ip
}

output "all_node_ips" {
  description = "All Kubernetes node IPs (control plane + workers)"
  value = concat(
    [aws_instance.control_plane.public_ip],
    aws_instance.workers[*].public_ip
  )
}
