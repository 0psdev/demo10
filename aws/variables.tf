variable "vpc_cidr" {
    description = "VPC name"
    type = string
  
}

variable "pubnet_names" {
    description = "public subnet name"
    type = list(string)
  
}

variable "pubnet_specs" {
    description = "public subnet specs"
    type = map(object({
        cidr_block = string
        availability_zone = string
        az = string
    }))
  
}   

variable "prinet_names" {
    description = "private subnet name"
    type = list(string)
  
}

variable "prinet_specs" {
    description = "private subnet specs"
    type = map(object({
        cidr_block = string
        availability_zone = string
        az = string
    }))
  
}   
