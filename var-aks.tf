# variables de keyvault, deben existir previamente y contener los secretos   
    variable "agent_count" {
        default = 2
    }
    variable "k8s_Version" {
        default = "1.16.10"
    }
   variable "admin_username" {
     default= "aksdevadmin"
   }
    variable "ssh_public_key" {
        default = "~/.ssh/id_rsa.pub"
    }

    variable log_analytics_workspace_name {
        default = ""
    }   
    
    variable log_analytics_workspace_sku {
        default = "PerGB2018"
    }
    variable "aad_group_name" {
        description = "Name of the Azure AD group for cluster-admin access"
        type        = string
    }
    variable "min_count" {
    default     = 1
    description = "Minimum Node Count"
    }
    variable "max_count" {
    default     = 5
    description = "Maximum Node Count"
    }
    variable "service_cidr" {
    description = "kubernetes internal service cidr range"
    default     = "10.250.0.0/16"
    }
    variable "dns_service_ip" {
    description = "kubernetes internal service cidr range"
    default     = "10.250.0.10"
    }