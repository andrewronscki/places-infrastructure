locals {
  common_tags = {
    Project   = "DevOps"
    UpdatedAt = timestamp()
    ManagedBy = "Terraform"
  }

  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}
