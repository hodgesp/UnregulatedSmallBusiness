
resource "azurerm_storage_account" "demostg" {
  name                     = "examplestoraccount12222"
  resource_group_name      = "${azurerm_resource_group.demo.name}"
  location                 = "${azurerm_resource_group.demo.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "vhds"
  storage_account_name  = "${azurerm_storage_account.demostg.name}"
  container_access_type = "private"
}