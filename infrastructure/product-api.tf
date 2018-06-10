resource "azurerm_template_deployment" "product" {
  name = "productapistemplate-01"
  resource_group_name = "${azurerm_resource_group.apis.name}"

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "app_service_plan_id": {
      "type": "string",
      "metadata": {
        "description": "App Service Plan ID"
      }
    },
    "name": {
      "type": "string",
      "metadata": {
        "description": "App Name"
      }
    },
    "docker_registry_url": {
      "type": "string"
    },
    "docker_registry_username": {
      "type": "string"
    },
    "docker_registry_password": {
      "type": "string"
    },
    "product_database_url": {
      "type": "string"
    },
    "image": {
      "type": "string",
      "metadata": {
        "description": "Docker image"
      }
    }
  },
  "resources": [
    {
      "apiVersion": "2016-03-01",
      "type": "Microsoft.Web/sites",
      "name": "[parameters('name')]",
      "properties": {
        "siteConfig": {
          "alwaysOn": true,
          "appSettings": [
              {
                  "name": "DOCKER_REGISTRY_SERVER_URL",
                  "value": "[parameters('docker_registry_url')]"
              },
              {
                  "name": "DOCKER_REGISTRY_SERVER_USERNAME",
                  "value": "[parameters('docker_registry_username')]"
              },
              {
                  "name": "DOCKER_REGISTRY_SERVER_PASSWORD",
                  "value": "[parameters('docker_registry_password')]"
              },
              {
                  "name": "WEBSITES_ENABLE_APP_SERVICE_STORAGE",
                  "value": "false"
              },
              {
                  "name": "DOCKER_ENABLE_CI",
                  "value": "true"
              },
              {
                  "name": "APP_APP_ENV",
                  "value": "prod"
              },
              {
                  "name": "APP_DATABASE_URL",
                  "value": "[parameters('product_database_url')]"
              }
          ],
          "appCommandLine": "",
          "linuxFxVersion": "[concat('DOCKER|', parameters('image'))]"
        },
        "name": "[parameters('name')]",
        "serverFarmId": "[parameters('app_service_plan_id')]",
        "hostingEnvironment":  ""
      },
      "location": "[resourceGroup().location]"
    }
  ]
}
DEPLOY

  parameters {
    name = "${var.env}-product-api-${random_integer.rg.result}-app"
    image = "${var.registry_name}/adicode/product-api:${var.env}"
    app_service_plan_id = "${azurerm_app_service_plan.product.id}"
    docker_registry_url = "https://${azurerm_container_registry.common.login_server}"
    docker_registry_username = "${azurerm_container_registry.common.admin_username}"
    docker_registry_password = "${azurerm_container_registry.common.admin_password}"
    product_database_url = "pgsql://${azurerm_postgresql_server.product-db.administrator_login}@${azurerm_postgresql_database.product-db.server_name}:${azurerm_postgresql_server.product-db.administrator_login_password}@${azurerm_postgresql_server.product-db.fqdn}/${azurerm_postgresql_database.product-db.name}"
  }

  deployment_mode = "Incremental"
}

output "product_api_name" {
  value = "${var.env}-product-api-${random_integer.rg.result}-app"
}

