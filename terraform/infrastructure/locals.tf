locals {
  name = "${var.project_name}-${var.env_name}"
  tags = {
    Environment        = var.env_name
    ManagedByTerraform = true
  }
}
