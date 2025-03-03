variable "AWS_ACCESS_KEY_ID" {
    description = "AWS access key"
    type = string
  
}

variable "AWS_SECRET_ACCESS_KEY" {
    description = "AWS key name"
    type = string
  
}

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
        desc = string
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
        desc = string
    }))
  
}

variable "prinet_az" {
    type = set(string)
}

variable "prinet_desc" {
    type = map(string)
 
}
