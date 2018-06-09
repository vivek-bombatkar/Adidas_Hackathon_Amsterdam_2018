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