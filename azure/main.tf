//Resource Group
resource "azurerm_resource_group" "rsg_names" {
    name     = var.rsg_names
    location = var.location_names
}
//Virtual Network
resource "azurerm_virtual_network" "vnetwork" {
  name = var.vnet_name
  resource_group_name = var.rsg_names
  location = var.location_names
  address_space = var.vnet_subnet
}
//Subnet
resource "azurerm_subnet" "snet" {
  for_each = toset(var.snet_names)
  name = each.key
  resource_group_name = var.rsg_names
  virtual_network_name = azurerm_virtual_network.vnetwork.name
  address_prefixes = var.snet_subnets[each.key]
}
//Public IP
resource "azurerm_public_ip" "my_public_ip" {
  name                = "public-ip-nat"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
//NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.natgw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
//NAT Gateway Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "ass_public_ip" {
  nat_gateway_id       = azurerm_nat_gateway.my_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.my_public_ip.id
}
//NAT Gateway Subnet Assoication
resource "azurerm_subnet_nat_gateway_association" "ass_subnet_nat" {
  subnet_id      = azurerm_subnet.snet["subnet_02"].id
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
}
//NIC vm
resource "azurerm_network_interface" "nic-vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}-nic"
  resource_group_name = var.rsg_names
  location            = var.location_names

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_names[each.key].subnet
    private_ip_address_allocation = "Dynamic"
  }
}
//NSG
resource "azurerm_network_security_group" "nsg-vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}-nsg"
  resource_group_name = var.rsg_names
  location            = var.location_names
}
//NSG Rule
resource "azurerm_network_security_rule" "rule_vm_1" {
  for_each = toset(var.vm_names)
  name                       = "allow_icmp"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "icmp"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = azurerm_network_interface.nic-vm[each.key].private_ip_address
  resource_group_name = var.rsg_names
  network_security_group_name = azurerm_network_security_group.nsg-vm[each.key].name
}
//NSG Rule Associate
resource "azurerm_network_interface_security_group_association" "nsg-ass-vm" {
  for_each = toset(var.vm_names)
  network_interface_id      = azurerm_network_interface.nic-vm[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg-vm[each.key].id
}
//Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = toset(var.vm_names)
  name                = "${each.key}"
  resource_group_name = var.rsg_names
  location = var.location_names
  size                = var.vm_specs[each.key].vm_size
  zone                = var.vm_specs[each.key].zone
  admin_username      = "test_admin"
  admin_password      = "P@$$w0rd1234!"
  computer_name = each.key
  network_interface_ids = [
    azurerm_network_interface.nic-vm[each.key].id
  ]

  os_disk {
    name                 = "${each.key}-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "24_04-lts"
    version   = "latest"
  }
}