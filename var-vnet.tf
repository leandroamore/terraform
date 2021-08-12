variable "vnet_resource_group_name" {
    type = string
    default = "PLGA_DEV_VNET"
}
variable "aks_vnet_name" {
    type = string
    default = "PLGA-Dev-VNET"
}
variable "address_space" {
    type = string
    default = "10.244.0.0/15"
}
variable "AKSSubnet" {
    type = string
    default = "10.244.0.0/16"
}
variable "WAFSubnet" {
    type = string
    default = "10.245.0.0/24"
}