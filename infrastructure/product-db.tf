variable "psql_administrator_login" {
  type        = "string"
  description = "username"
  default     = "superuser"
}

variable "psql_database_name" {
  type        = "string"
  description = "psql database name."
  default     = "product"
}

resource "random_string" "db-password" {
  length = 16
  special = true
  override_special = "/@\" "
}


resource "azurerm_resource_group" "product-db" {
  name     = "adicode-${var.locationShort}-product-db-${random_integer.rg.result}rg"
  location = "${var.location}"

  tags {
    org = "adicode"
    service = "product-db"
    location = "${var.locationShort}"
  }
}

resource "azurerm_postgresql_server" "product-db" {
  name                = "adicode-${var.locationShort}-product-db-${random_integer.rg.result}"
  location            = "${azurerm_resource_group.product-db.location}"
  resource_group_name = "${azurerm_resource_group.product-db.name}"

  sku {
    name = "B_Gen4_2"
    capacity = 2
    tier = "Basic"
    family = "Gen4"
  }

  storage_profile {
    storage_mb = 5120
    backup_retention_days = 7
    geo_redundant_backup = "Disabled"
  }

  administrator_login          = "${var.psql_administrator_login}"
  administrator_login_password = "${random_string.db-password.result}"

  version = "9.6"
  ssl_enforcement = "Enabled"
}

resource "azurerm_postgresql_database" "product-db" {
  name                = "${var.psql_database_name}"
  resource_group_name = "${azurerm_resource_group.product-db.name}"
  server_name         = "${azurerm_postgresql_server.product-db.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

output "psql_database_name" {
  value = "${var.psql_database_name}"
}

output "psql_administrator_login" {
  value = "${var.psql_administrator_login}"
}

output "psql_administrator_password" {
  value = "${random_string.db-password.result}"
}

