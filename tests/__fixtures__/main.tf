resource "null_resource" "test" {}

resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "canadacentral"
}
