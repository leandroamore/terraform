terraform {
  backend "azurerm" {
    key                  = "Prod.vuas.tfstate"
  }
}