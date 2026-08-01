resource "azurerm_subnet" "subnet" {
    for_each = var.subnet
name                 = each.value.name
  resource_group_name  = "bunty-rg"
  virtual_network_name = "bunty-vnet"
  address_prefixes     = ["10.0.1.0/24"]

}