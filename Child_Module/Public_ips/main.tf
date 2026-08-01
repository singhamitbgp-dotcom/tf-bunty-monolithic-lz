resource "azurerm_public_ip" "public-ip" {
    for_each = var.public_ips
  name                    = "bunty-pip"
  location                = "Central India"
  resource_group_name     = "bunty-rg"
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}