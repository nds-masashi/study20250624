variable "resourceName" {}
variable "specificAddress" {}

module "main" {
  source = "../../modules/app"

  resourceName    = var.resourceName
  specificAddress = var.specificAddress
}
