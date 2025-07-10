terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.93.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "3a734e32-021d-4243-89ff-c3495e6aa4da"
}