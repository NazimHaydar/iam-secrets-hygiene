# --------------------------------------------------------------
# SECRETS MANAGER
# Instead of hardcoding sensitive values (passwords, API keys)
# directly in .tf files or committing them to Git, we store them
# in AWS Secrets Manager - Terraform only references the secret,
# it never contains the actual sensitive value in the code itself.
# --------------------------------------------------------------

resource "aws_secretsmanager_secret" "db_password" {
  name        = "demo-db-password"
  description = "Example: a database password stored securely, not hardcoded"

  tags = {
    Name = "demo-db-password"
  }
}

# The actual secret VALUE is set separately from the secret's
# definition. This value comes from a variable (see variables.tf)
# rather than being typed directly into this file - so it's never
# visible in your Git history.
resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}