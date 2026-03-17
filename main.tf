terraform {
    required_providers {
        azurerm ={
            source = "hashicorp/azurerm"
            version = "= 2.46.0"
        }
    }
    required_version = ">=1.0.1"
}

#provider block

provider "azurerm" {
    features {}
}

#resource block 
#creating a resource group
resource "azurerm_resource_group" "RG"{
    name =var.rgname
    location =var.rglocation
}
#creating VNET
resource "azurerm_virtual_network" "VNET"{
    name                = var.vnetname
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
}
#creating subnet
resource "azurerm_subnet" "SUBNET" {
    name = var.subnetname
    resource_group_name  = azurerm_resource_group.RG.name
    virtual_network_name = azurerm_virtual_network.VNET.name
    address_prefixes     = ["10.0.0.0/24"]
}
#creating public IP to access (If you want to access the VM using public IP then only you can create public IP)
resource "azurerm_public_ip" "PUBLIC_IP" {
  name                = var.vm_public_ip
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
#creating private IP to access (If you want to access the VM using private IP then only you can create private IP)
resource "azurerm_network_interface" "NIC"{
    name                = var.privatenic
    resource_group_name = azurerm_resource_group.RG.name
    location            = azurerm_resource_group.RG.location

    #Assigning NICs
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.SUBNET.id
        private_ip_address_allocation = "Dynamic" #Static   
    }
}

#Creating VM
resource "azurerm_windows_virtual_machine" "VM" {
    name                = var.vmname
    resource_group_name = azurerm_resource_group.RG.name
    location            = azurerm_resource_group.RG.location
    size                = var.vmsize
    admin_username      = var.username
    admin_password      = var.pswd
    network_interface_ids = [azurerm_network_interface.NIC.id]

    source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
  }

  tags = {
    environment = "Test"
  }
}

# Define a network security group (NSG) for the VM
resource "azurerm_network_security_group" "NSGRULE" {
  name                = var.nsg
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "RDP"
    priority                   = 200 #100-4096
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# To attach a any additional disk, we must need the managed disk.
resource "azurerm_managed_disk" "ManagedDisk" {
  name                 = var.manageddiskname
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "staging"
  }
}

#Attaching the additional data disk
resource "azurerm_virtual_machine_data_disk_attachment" "datadisk1" {
  managed_disk_id    = azurerm_managed_disk.ManagedDisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.VM.id
  lun                = "1"
  caching            = "ReadWrite"
}
