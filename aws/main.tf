//VPC
resource "aws_vpc" "vpc_demo" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Project = "demo"
        Type = "vpc"
        Name = "vpc"
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
        Name = var.pubnet_specs[each.key].Name
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
        Name = var.prinet_specs[each.key].Name
    }
  
}
//Intenet Gateway
resource "aws_internet_gateway" "igw_demo" {
    vpc_id = aws_vpc.vpc_demo.id
    tags = {
        Project = "demo"
        Type = "igw"
        Name = "internet gatway"
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
        Name = "public route table"
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
        Name = "Public IP"
    }
  
}
//Nat Gateway
resource "aws_nat_gateway" "natgw_demo" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.pubsub_demo["pubnetaz1"].id
    tags = {
        Project = "demo"
        Type = "natgw"
        Name = "Nat Gateway"
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
        Name = "private route table"
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
        Name = "security group"
    }
}
//Ec2 Instance
resource "aws_instance" "ec2_nat" {
    for_each = toset(var.prinet_az)
    ami = "ami-0726c8f833d8aea08"
    instance_type = "t1.micro"
    subnet_id = aws_subnet.prisub_demo[each.key].id
    security_groups = [aws_security_group.sg_demo.id]
    tags = {
        Project = "demo"
        Type = "ec2"
        Az = each.key
    }
}