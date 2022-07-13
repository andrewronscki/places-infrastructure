locals {
  common_tags = {
    Project   = "DevOps"
    UpdatedAt = timestamp()
    ManagedBy = "Terraform"
  }

  service_url = "api.places.andrewronscki.com"
}
