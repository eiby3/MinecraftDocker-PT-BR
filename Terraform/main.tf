terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "suasubscriptionId"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "primeira-vm"
  location              = azurerm_resource_group.grupo.location
  resource_group_name   = azurerm_resource_group.grupo.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "meudisco1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-azure"
    admin_username = "abe"
    admin_password = "Testando1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_resource_group" "grupo" {
  name     = "recursos"
  location = "brazilsouth"
}
