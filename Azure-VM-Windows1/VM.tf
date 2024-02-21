resource "azurerm_public_ip" "public_ip" {
  name                = var.publicip_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "WindowsVM" {
  name                  = var.vm_name
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  computer_name         = "WindowsVM"

   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  /*
  plan {
   name = "belvmsrviis01"
   publisher = "belindaczsro1588885355210"
   product = "belvmsrviis"
  }
  source_image_reference {
    publisher = "belindaczsro1588885355210"
    offer     = "belvmsrviis"
    sku       = "belvmsrviis01"
    version   = "latest"
  }	*/
}
resource "azurerm_virtual_machine_extension" "disablingfirewall" {
  name                       = "extension1"
  virtual_machine_id         = azurerm_windows_virtual_machine.WindowsVM.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File newfirewall.ps1",
        "fileUris": [
          "https://firewallstg.blob.core.windows.net/firewallcontainer?sp=r&st=2024-02-21T11:45:57Z&se=2024-02-21T19:45:57Z&spr=https&sv=2022-11-02&sr=c&sig=gVQ1dBzXIpv9%2FUO3E16Ix4%2Bws4wI7BgAhB9ax%2FBrjJY%3D"
        ]
    }
  SETTINGS
}
