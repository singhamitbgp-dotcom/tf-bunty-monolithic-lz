resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  size                = each.value.size

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  network_interface_ids = [
    each.value.network_interface_id
  ]

  os_disk {
    name                 = each.value.os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}