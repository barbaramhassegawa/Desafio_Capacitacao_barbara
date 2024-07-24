terraform {
   required_providers {
     azurerm   = {
       source  = "hashicorp/azurerm"
       version = "~> 2.65"

     }
   }    
}

provider "azurerm" {
  features {}
}

# Backend
terraform {
 backend "azurerm" {
   resource_group_name  = "rg-desafio-tfstate"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
   storage_account_name = "desafiomintfstate"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
   container_name       = "tfstate"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
   key                  = "staging.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
 }
}


#Para criar uma virtual network preciso ter um resource group
#Criação de uma Resource group

resource "azurerm_resource_group" "default" {
 name     = var.rg
 location = var.locat
 tags     = {
   "env": "staging"
   "project": "desafiocapacitacao"
   "costcenter": "001"
 }
}


# Criação Virtual network
resource "azurerm_virtual_network" "default" {
 name                = "vnet-desafio-iac"
 address_space       = ["10.0.0.0/16"]
 location            = var.locat
 resource_group_name = var.rg
 tags = {
   "env": "staging"
   "project": "desafiocapacitacao"
 }
}

# Criação da primeira subnet

resource "azurerm_subnet" "internal" {
 name                 = "internal"
 resource_group_name  = var.rg
 virtual_network_name = var.vnet
 address_prefixes     = ["10.0.1.0/24"]
}

# Criação da segunda subnet

resource "azurerm_subnet" "staging" {
  name                 = "staging"
  resource_group_name  = var.rg
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.10.0/24"]
}

# Criação máquina virtual

resource "azurerm_public_ip" "default" {
  name                = "${var.vm}-pi"
  resource_group_name = var.rg
  location            = var.locat
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.vm}-nsg"
  location            = var.locat
  resource_group_name = var.rg


  security_rule {

    name                       = "SSH"
    priority                   = "200"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Ciração da Interface de Rede
resource "azurerm_network_interface" "default" {
  name                = "${var.vm}-nic"
  location            = var.locat
  resource_group_name = var.rg

  ip_configuration {
   name                          = "${var.vm}-ipconfig"
   subnet_id                     = azurerm_subnet.internal.id
   private_ip_address_allocation = "Dynamic"
   public_ip_address_id          = azurerm_public_ip.default.id
 }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_virtual_machine" "main" {
 name                  = var.vm
 location              = var.locat
 resource_group_name   = var.rg
 network_interface_ids = [azurerm_network_interface.default.id]
 vm_size               = "Standard_B1s"



  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


 os_profile {
   computer_name  = var.vm
   admin_username = "admaz"
   admin_password = "P12341234!"
   custom_data = filebase64("${path.module}/setup_docker.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Recurso de Extensão da Máquina Virtual para o Custom Script
resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "setup-docker-extension"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

 settings = <<SETTINGS
  {
    "commandToExecute": "echo '<setup_docker.sh>' | base64 -d | sudo bash"
  }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": "bash setup_docker.sh"
    }
  PROTECTED_SETTINGS
}

output "public_ip_address" {
  value = azurerm_public_ip.default.ip_address
}


