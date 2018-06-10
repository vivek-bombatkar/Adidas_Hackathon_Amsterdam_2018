terraform {
  backend "azurerm" {
    storage_account_name = "adicodecommon"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "random_integer" "rg" {
  min = 10
  max = 99
}

resource "azurerm_resource_group" "common" {
  name     = "adicode-${var.locationShort}-common-${random_integer.rg.result}rg"
  location = "${var.location}"

  tags {
    org = "adicode"
    location = "${var.locationShort}"
  }
}

resource "random_integer" "container_registry" {
  min = 100
  max = 999
}

resource "azurerm_storage_account" "container_registry" {
  name                     = "adicodecr${random_integer.rg.result}"
  resource_group_name      = "${azurerm_resource_group.common.name}"
  location                 = "${azurerm_resource_group.common.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_container_registry" "common" {
  name                = "${var.registry_name}"
  resource_group_name = "${azurerm_resource_group.common.name}"
  location            = "${azurerm_resource_group.common.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.container_registry.id}"
}

output "container_registry_username" {
  value = "${azurerm_container_registry.common.admin_username}"
}

output "container_registry_password" {
  value = "${azurerm_container_registry.common.admin_password}"
}

output "container_registry_server" {
  value = "${azurerm_container_registry.common.login_server}"
}
