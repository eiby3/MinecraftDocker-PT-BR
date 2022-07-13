resource "azurerm_virtual_network" "main" {
  name                = "rede-privada"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.grupo.location
  resource_group_name = azurerm_resource_group.grupo.name
}
resource "azurerm_public_ip" "example" {
  name                = "example-PIP"
  location            = azurerm_resource_group.grupo.location
  resource_group_name = azurerm_resource_group.grupo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "example" {
  name                = "example-NatGateway"
  location            = azurerm_resource_group.grupo.location
  resource_group_name = azurerm_resource_group.grupo.name
  sku_name            = "Standard"
}

resource "azurerm_subnet" "interna" {
  name                 = "interna"
  resource_group_name  = azurerm_resource_group.grupo.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "meu-nic"
  location            = azurerm_resource_group.grupo.location
  resource_group_name = azurerm_resource_group.grupo.name

  ip_configuration {
    name                          = "teste1"
    subnet_id                     = azurerm_subnet.interna.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}