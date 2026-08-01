
output "nic_id" {
  value = {
    for k, v in azurerm_network_interface.nic :
    k => v.id
  }
}

resource "azurerm_network_interface" "nic" {
  for_each = var.nic

  name                = "bunty-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }

}