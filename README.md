# IAM & Secrets Hygiene (Terraform)

A demonstration of security best practices for AWS infrastructure: least-privilege IAM policies and proper secrets management, both defined as code.

## What this creates

- **IAM Role** (`ci-pipeline-role`) — an identity intended for CI/CD pipelines, scoped narrowly rather than using broad admin access
- **IAM Policy** (`ecr-push-pull-policy`) — grants only the specific ECR actions needed to push and pull container images, restricted to one named repository
- **Role-Policy Attachment** — connects the policy to the role
- **Secrets Manager secret** — demonstrates storing a sensitive value (e.g. a database password) securely, referenced by Terraform but never hardcoded or committed to Git

## Why this matters

Most tutorials and quick-start guides use `AdministratorAccess` for simplicity — including earlier setup work in this portfolio. That's fine for personal learning, but it's not how production systems should be configured. This project demonstrates the alternative:

- **Least privilege**: the IAM policy lists only the exact actions required (`ecr:PutImage`, `ecr:BatchGetImage`, etc.) and scopes them to a single repository ARN — not `"Resource": "*"` across the account
- **Secrets never touch source control**: the actual secret value lives in `terraform.tfvars`, which is excluded from Git via `.gitignore`. Terraform references it through a `sensitive` variable, and the value itself is stored in AWS Secrets Manager — not typed into any `.tf` file that gets committed
- **Auditable by design**: because both the IAM policy and secret *definition* are code, they can be reviewed in a pull request before being applied — access changes aren't invisible console clicks

## Tech stack

Terraform · AWS IAM · AWS Secrets Manager

## Project structure

```
.
├── iam.tf           # IAM role, policy, and attachment
├── secrets.tf       # Secrets Manager secret and version
├── variables.tf     # Input variables, including the sensitive db_password
├── .gitignore       # Excludes terraform.tfvars and state files from Git
└── README.md
```

## How to run

Create a `terraform.tfvars` file locally (this file is intentionally not committed):
```
db_password = "your-example-value"
```

Then:
```
terraform init
terraform plan
terraform apply
```

To tear down all resources:
```
terraform destroy
```

## What I learned building this

- The practical difference between a working setup and a *secure* one — broad permissions get things done, but least-privilege scoping is what real production environments require
- How Terraform's `sensitive = true` variable flag and `.gitignore` work together to keep secret values out of both console output and version history
- That IAM policies should be scoped to specific resource ARNs wherever possible, not left open with wildcards, even when it would be faster to write

## Author

**Nazim Haydar**
IT Support / Network Engineer transitioning into Cloud & DevOps Engineering
[GitHub](https://github.com/NazimHaydar)
