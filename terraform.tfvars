#pre requisitos

#AKS
k8s_Version                     = "1.20.7"
agent_count                     = 3
admin_username                  = "vuasadmin"
ssh_public_key                  = "~/.ssh/id_rsa_aksprod.pub"
aad_group_name                  = "AKS Prod Admins"
#VNET
#address_space                   = "172.16.62.0/24"
#Subnet                          = "172.16.62.0/24"

#Generales
location                        = "eastus"
tags                            = {Environment = "Prod", Deployment = "Vuas as a Service"}
