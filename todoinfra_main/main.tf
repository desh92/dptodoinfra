module "resource_group" {
  source              = "../modules/azurerm_resource_group"
  resource_group_name = "tondu-rg"
  location            = "centralindia"
}

# #rg added in feature/101
# module "resource_group" {
#   source              = "../modules/azurerm_resource_group"
#   resource_group_name = "tondu-rg1"
#   location            = "centralindia"
# }

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../modules/azurerm_virtual_network"

  virtual_network_name = "tondu_vnet"
  location             = "centralindia"
  resource_group_name  = "tondu-rg"
  address_space        = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  subnet_name          = "tondu-fesubnet"
  resource_group_name  = "tondu-rg"
  virtual_network_name = "tondu_vnet"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../modules/azurerm_subnet"

  subnet_name          = "tondu-besubnet"
  resource_group_name  = "tondu-rg"
  virtual_network_name = "tondu_vnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "public_ip_fe" {
  depends_on = [ module.resource_group ]
  source     = "../modules/azurerm_public_ip"

  pip_name            = "tondu-fe-pip"
  resource_group_name = "tondu-rg"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "public_ip_be" {
  depends_on = [ module.resource_group ]
  source     = "../modules/azurerm_public_ip"

  pip_name            = "tondu-be-pip"
  resource_group_name = "tondu-rg"
  location            = "centralindia"
  allocation_method   = "Static"
}

module "frontend_vm" {
  depends_on = [module.frontend_subnet]
  source     = "../modules/azurerm_virtual_machine"

  vm_name             = "tondu-fe-vm"
  location            = "centralindia"
  resource_group_name = "tondu-rg"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-focal"
  image_sku           = "20_04-lts"
  subnet_id           = "/subscriptions/3a734e32-021d-4243-89ff-c3495e6aa4da/resourceGroups/tondu-rg/providers/Microsoft.Network/virtualNetworks/tondu_vnet/subnets/tondu-fesubnet"
  nic_name            = "tondu-fe-nic"
  pip_id = "/subscriptions/3a734e32-021d-4243-89ff-c3495e6aa4da/resourceGroups/tondu-rg/providers/Microsoft.Network/publicIPAddresses/tondu-fe-pip"
}

module "backend_vm" {
  depends_on = [module.backend_subnet]
  source     = "../modules/azurerm_virtual_machine"

  vm_name             = "tondu-be-vm"
  location            = "centralindia"
  resource_group_name = "tondu-rg"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-focal"
  image_sku           = "20_04-lts"
  subnet_id           = "/subscriptions/3a734e32-021d-4243-89ff-c3495e6aa4da/resourceGroups/tondu-rg/providers/Microsoft.Network/virtualNetworks/tondu_vnet/subnets/tondu-besubnet"
  nic_name            = "tondu-be-nic"
  pip_id = "/subscriptions/3a734e32-021d-4243-89ff-c3495e6aa4da/resourceGroups/tondu-rg/providers/Microsoft.Network/publicIPAddresses/tondu-be-pip"
}

module "sql_server" {
  source = "../modules/azurerm_sql_server"

  sql_server_name     = "tondu-sql-server"
  resource_group_name = "tondu-rg"
  location            = "centralindia"
}

module "sql_database" {
  source = "../modules/azurerm_database"

  sql_database_name = "tondu-sql-db"
  sql_server_id     = "/subscriptions/3a734e32-021d-4243-89ff-c3495e6aa4da/resourceGroups/tondu-rg/providers/Microsoft.Sql/servers/tondu-sql-server"

}