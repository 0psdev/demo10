variable "subscription_id" {
    description = "subscription id"
    type = string
}

variable "tenant_id" {
    description = "tenant id"
    type = string
}

variable "rsg_names" {
    description = "resource group name"
    type = string
}

variable "location_names" {
    description = "location name"
    type = string
}

variable "storage_account_name" {
    description = "storage account name"
    type = string
}

variable "vnet_name" {
    description = "vnet name"
    type = string
}

variable "vnet_subnet" {
    description = "vnet subnet"
    type = list(string)
}

variable "snet_names" {
    description = "subnet name"
    type = list(string)
}

variable "snet_subnets" {
    description = "subnet subnets"
    type = map(list(string))
}

variable "public_ip_name" {
    description = "public ip name"
    type = string
  
}

variable "natgw_name" {
    description = "nat gateway name"
    type = string
  
}

variable "vm_names" {
    description = "vm name"
    type = list(string)
  
}

variable "vm_specs" {
    description = "vm specs"
    type = map(object({
        vm_size = string
        zone = string
        subnet = string
   }))
  
}