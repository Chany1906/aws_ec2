output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.example.id
}

output "public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.example.public_ip
}
