resource "azurerm_resource_group" "resourcegroupvm" {
  name = "resourcegroupvm"
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "vmvirtualnetwork" {
  name = "vmvirtualnetwork"
  location = var.location
  resource_group_name = azurerm_resource_group.resourcegroupvm.name
  address_space = [ "10.6.0.0/16" ]
  tags = var.tags


}

resource "azurerm_subnet" "vmvirtualnetworksubnet" {
  name = "vmvirtualnetworksubnet"
  address_prefixes = [ "10.6.0.0/27" ]
  virtual_network_name = azurerm_virtual_network.vmvirtualnetwork.name
  resource_group_name = azurerm_resource_group.resourcegroupvm.name
}

resource "azurerm_public_ip" "vmpip" {
  count = var.instanceCount
  name = "vmpip${(count.index)+1}"
  location = var.location
  resource_group_name = azurerm_resource_group.resourcegroupvm.name
  tags = var.tags
  sku = "Basic"
  sku_tier = "Regional"
  allocation_method = "Dynamic"
}


resource "azurerm_network_interface" "vmnic" {
  count = var.instanceCount
  name = "vmnic${(count.index)+1}"
  location = var.location
  resource_group_name = azurerm_resource_group.resourcegroupvm.name
  tags = var.tags
  ip_configuration {
    name = "ipconfigvm"
    public_ip_address_id = azurerm_public_ip.vmpip[count.index].id
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.vmvirtualnetworksubnet.id

      }

}

resource "azurerm_windows_virtual_machine" "vm1" {
  count = var.instanceCount
  name = "vm1${(count.index)+1}"
  location = var.location
  resource_group_name = azurerm_resource_group.resourcegroupvm.name
  size = "Standard_F2"
  admin_username = "azureadmin"
  admin_password = "Azure@12345"
  network_interface_ids = [
    azurerm_network_interface.vmnic[count.index].id,
  ]  

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

}