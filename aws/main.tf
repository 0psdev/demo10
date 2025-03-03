//VPC
resource "vpc_demo" "vpc_demo" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Project = "demo"
        Type = "vpc"
    }
  
}
//Public Subnet
resource "pubsubnet_demo" "pubsub_demo" {
    for_each = toset(var.pubnet_names)
    vpc_id = vpc_demo.vpcdemo.id
    cidr_block = var.pubnet_specs[each.key].cidr_block
    availability_zone = var.pubnet_specs[each.key].availability_zone
    map_public_ip_on_launch = true
    tags = {
        Project = "demo"
        Type = "subnet"
        Az = var.pubnet_specs[each.key].az
    }
  
}
//Private Subnet
resource "subnet_demo" "prisub_demo" {
    for_each = toset(var.prinet_names)
    vpc_id = vpc_demo.vpcdemo.id
    cidr_block = var.prinet_specs[each.key].cidr_block
    availability_zone = var.prinet_specs[each.key].availability_zone
    tags = {
        Project = "demo"
        Type = "subnet"
        Az = var.prinet_specs[each.key].az
    }
  
}
//Intenet Gateway
resource "igw_demo" "igw_demo" {
    vpc_id = vpc_demo.vpcdemo.id
    tags = {
        Project = "demo"
        Type = "igw"
    }
  
}
//Route Table Public
resource "rt_public_demo" "rt_public_demo" {
    vpc_id = vpc_demo.vpcdemo.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = igw_demo.igw_demo.id
        tags = {
            Project = "demo"
            Type = "rt"
        }
    }
  
}
//Route Table Association Puiblic
resource "rta_public_demo" "rta_public_demo" {
    for_each = toset(var.pubnet_names)
    subnet_id = pubsubnet_demo.pubsub_demo[each.key].id
    route_table_id = rt_demo.rt_demo.id
    tags = {
        Project = "demo"
        Type = "rta"
    }
  
}
//Elastic IP
resource "aws_eip" "nat_eip" {
    associate_with_private_ip = true
    tags = {
        Project = "demo"
        Type = "eip"
    }
  
}
//Nat Gateway
resource "natgw_demo" "natgw_demo" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = pubsubnet_demo.pubsub_demo[each.key].id
    tags = {
        Project = "demo"
        Type = "natgw"
    }
    depends_on = [aws_eip.nat_eip]
  
}
//Route Table Private
resource "rt_private_demo" "rt_private_demo" {
    vpc_id = vpc_demo.vpcdemo.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = natgw_demo.natgw_demo.id
    tags = {
        Project = "demo"
        Type = "rt"
    }
}

}
//Route Table Association Private
resource "rta_private_demo" "rta_private_demo" {
    for_each = toset(var.prinet_names)
    subnet_id = subnet_demo.prisub_demo[each.key].id
    route_table_id = rt_private_demo.rt_private_demo.id
    tags = {
        Project = "demo"
        Type = "rta"
    }
  
}
