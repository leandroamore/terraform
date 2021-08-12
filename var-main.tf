#Generales
variable "location" {
    type        = string
    default = "East US"
    }

variable "environment" {
    type        = string
    default     = "prod"
}
variable "prefix" {
    type        = string
    default     = "VuaS"
}

variable tags {
    type = map
    default = {
        Environment = "prod"
        Deployment = "VuaS as a Service"
    }
    }
