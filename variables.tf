variable "aws_region" {
  description = "Región AWS"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID para EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del par de llaves SSH"
  type        = string
}

variable "security_group_id" {
  description = "ID del grupo de seguridad"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred"
  type        = string
}
