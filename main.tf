terraform {

#   backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.27"
    }
 }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "resource-group" {
    source = "./modules/resource-group"
    location = "eastus"
    name = "cg-aks-test-rg"
}

module "virtual-network" {
    source = "./modules/virtual-network"
    location = module.resource-group.location
    resource_group_name = module.resource-group.name
    name = "vnet"
}

module "apim-subnet" {
    source = "./modules/subnet"
    name = "apim-subnet"
    resource_group_name = module.resource-group.name
    vnet_name = module.virtual-network.name
    address_prefixes = "10.10.10.0/24"
}

module "services-subnet" {
    source = "./modules/subnet"
    name = "services-subnet"
    resource_group_name = module.resource-group.name
    vnet_name = module.virtual-network.name
    address_prefixes = "10.10.25.0/24"
}

module "aks-cluster" {
    source = "./modules/kubernetes-cluster"
    name = "aks-testcluster"
    location = module.resource-group.location
    resource_group_name = module.resource-group.name
    vnet_subnet_id = module.apim-subnet.id
    identity_id = module.aks-identity.id
    depends_on = [
      module.aks-route-table-association,
      module.aks-role-assignment
    ]
}

module "aks-route-table" {
    source = "./modules/route-table"
    name = "aks-route"
    resource_group_name = module.resource-group.name
    location = module.resource-group.location
    # TODO extrapolate this better
    address_prefix = "10.10.25.0/24"
}

module "aks-route-table-association" {
    source = "./modules/route-table-association"
    subnet_id = module.apim-subnet.id
    route_table_id = module.aks-route-table.id
}

module "services-subnet-route-table-association" {
    source = "./modules/route-table-association"
    subnet_id = module.services-subnet.id
    route_table_id = module.aks-route-table.id
}

module "aks-identity" {
    source = "./modules/user-assigned-identity"
    resource_group_name = module.resource-group.name
    location = module.resource-group.location
}

module "aks-role-assignment" {
    source = "./modules/role-assignment"
    scope = module.resource-group.id
    principal_id = module.aks-identity.principal_id
    depends_on = [
      module.aks-identity
    ]
}