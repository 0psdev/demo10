//VPC
resource "aws_vpc" "vpc_demo" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Project = "demo"
        Type = "vpc"
        Desc = "vpc"
    }
}
//Public Subnet
resource "aws_subnet" "pubsub_demo" {
    for_each = toset(var.pubnet_names)
    vpc_id = aws_vpc.vpc_demo.id
    cidr_block = var.pubnet_specs[each.key].cidr_block
    availability_zone = var.pubnet_specs[each.key].availability_zone
    map_public_ip_on_launch = true
    tags = {
        Project = "demo"
        Type = "subnet"
        Az = var.pubnet_specs[each.key].az
        Desc = var.pubnet_specs[each.key].desc
    }
  
}
//Private Subnet
resource "aws_subnet" "prisub_demo" {
    for_each = toset(var.prinet_names)
    vpc_id = aws_vpc.vpc_demo.id
    cidr_block = var.prinet_specs[each.key].cidr_block
    availability_zone = var.prinet_specs[each.key].availability_zone
    tags = {
        Project = "demo"
        Type = "subnet"
        Az = var.prinet_specs[each.key].az
        Desc = var.prinet_specs[each.key].desc
    }
  
}
//Intenet Gateway
resource "aws_internet_gateway" "igw_demo" {
    vpc_id = aws_vpc.vpc_demo.id
    tags = {
        Project = "demo"
        Type = "igw"
        Desc = "internet gatway"
    }
  
}
//Route Table Public
resource "aws_route_table" "rt_public_demo" {
    vpc_id = aws_vpc.vpc_demo.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_demo.id
    }
    tags = {
        Project = "demo"
        Type = "rt"
        Desc = "public route table"
    }
}
//Route Table Association Public
resource "aws_route_table_association" "rta_public_demo" {
    for_each = toset(var.pubnet_names)
    subnet_id = aws_subnet.pubsub_demo[each.key].id
    route_table_id = aws_route_table.rt_public_demo.id

}
//Elastic IP
resource "aws_eip" "nat_eip" {
    associate_with_private_ip = true
    tags = {
        Project = "demo"
        Type = "eip"
        Desc = "Public IP"
    }
  
}
//Nat Gateway
resource "aws_nat_gateway" "natgw_demo" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.pubsub_demo["pubnetaz1"].id
    tags = {
        Project = "demo"
        Type = "natgw"
        Desc = "Nat Gateway"
    }
    depends_on = [aws_eip.nat_eip]
}
//Route Table Private
resource "aws_route_table" "rt_private_demo" {
    vpc_id = aws_vpc.vpc_demo.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw_demo.id
    }
    tags = {
        Project = "demo"
        Type = "rt"
        Desc = "private route table"
    }
}

//Route Table Association Private
resource "aws_route_table_association" "rta_private_demo" {
    for_each = toset(var.prinet_names)
    subnet_id = aws_subnet.prisub_demo[each.key].id
    route_table_id = aws_route_table.rt_private_demo.id
  
}
//Security Group
resource "aws_security_group" "sg_demo" {
    vpc_id = aws_vpc.vpc_demo.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "all"
        cidr_blocks = ["0.0.0.0/0"]
    }  
    egress {
        from_port = 0
        to_port = 0
        protocol = "all"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Project = "demo"
        Type = "sg"
        Desc = "security group"
    }
}
//Ec2 Instance
resource "aws_instance" "ec2_nat" {
    for_each = toset(var.prinet_az)
    ami = "ami-0b03299ddb99998e9"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.prisub_demo[each.key].id
    security_groups = [aws_security_group.sg_demo.id]
    monitoring = true
    key_name = "demo_key_ec2"
    tags = {
        Project = "demo"
        Type = "ec2"
        Az = each.key
    }
}