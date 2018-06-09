resource "azurerm_resource_group" "apis" {
  name     = "adicode-${var.locationShort}-apis-${random_integer.rg.result}rg"
  location = "${var.location}"

  tags {
    org = "adicode"
    service = "apis"
    location = "${var.locationShort}"
  }
}

resource "azurerm_app_service_plan" "product" {
  name                = "adicode-${var.locationShort}-apis-${random_integer.rg.result}-sp"
  location            = "${azurerm_resource_group.apis.location}"
  resource_group_name = "${azurerm_resource_group.apis.name}"
  kind                = "linux"

  sku {
    tier = "Basic"
    size = "B1"
  }

  properties {
    reserved = true
  }
}

