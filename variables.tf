variable "db_password" {
  description = "Example database password - passed in via terraform.tfvars, never hardcoded or committed"
  type        = string
  sensitive   = true
}