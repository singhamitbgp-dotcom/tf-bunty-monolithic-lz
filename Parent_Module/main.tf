module "resource_group" {
  source = "../Child_Module/Resource_Group"

  resource_group = {
    bunty-rg = "Central India"
  }
}

module "vnet" {
  source = "../Child_Module/Virtual_Network"

  depends_on = [module.resource_group]

  vnet = {
    vnet1 = {
      name           = "bunty-vnet"
      resource_group = "bunty-rg"
      location       = "Central India"
    }
  }
}

module "subnet" {
  source = "../Child_Module/Subnets"

  depends_on = [module.vnet]

  subnet = {
    subnet1 = {
      name                 = "bunty-subnet"
      resource_group       = "bunty-rg"
      virtual_network_name = "bunty-vnet"
      location             = "Central India"
    }
  }
}

module "nsg" {
  source = "../Child_Module/network_security_groups"

  depends_on = [module.subnet]

  nsg = {
    nsg1 = {
      name           = "bunty-nsg"
      resource_group = "bunty-rg"
      location       = "Central India"
    }
  }
}

module "public_ip" {
  source = "../Child_Module/Public_ips"

  depends_on = [module.nsg]

  public_ips = {
    pip1 = {
      name              = "bunty-pip"
      resource_group    = "bunty-rg"
      location          = "Central India"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }
}

data "azurerm_subnet" "bunty-subnet" {
  depends_on = [module.subnet]

  name                 = "bunty-subnet"
  virtual_network_name = "bunty-vnet"
  resource_group_name  = "bunty-rg"
}

module "nic" {
  source = "../Child_Module/NIC"

  depends_on = [
    module.subnet,
    module.public_ip
  ]

  nic = {
    nic1 = {
      name                          = "bunty-nic"
      location                      = "Central India"
      resource_group_name           = "bunty-rg"
      subnet_id                     = data.azurerm_subnet.bunty-subnet.id
      ip_configuration_name         = "ipconfig1"
      private_ip_address_allocation = "Dynamic"

      tags = {
        environment = "test"
      }
    }
  }
}

module "vm" {
  source = "../Child_Module/VM"

  depends_on = [module.nic]

  vm = {
    vm1 = {
      name                 = "bunty-vm"
      location             = "Central India"
      resource_group_name  = "bunty-rg"
      network_interface_id = module.nic.nic_id["nic1"]

      size           = "Standard_D2s_v3"
      admin_username = "azureamit"
      admin_password = "Amit@098765"

      os_disk_name = "bunty-osdisk"

      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }
  }
}