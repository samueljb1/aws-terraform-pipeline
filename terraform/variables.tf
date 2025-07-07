variable "project_name" {
  default = "aws-pipeline"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "PruebaTecAWS!2025"
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"  # Para prueba, se puede restringir
}
