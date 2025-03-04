vpc_cidr = "192.168.0.0/17"

pubnet_names = [ "pubnetaz1", "pubnetaz2" ]

pubnet_specs = {
  "pubnetaz1" = {
    cidr_block = "192.168.0.0/24"
    availability_zone = "ap-southeast-1a"
    az = "az1"
    desc = "public subnet in AZ1"
  },
  "pubnetaz2" = {
    cidr_block = "192.168.64.0/24"
    availability_zone = "ap-southeast-1b"
    az = "az2"
    desc = "public subnet in AZ2"
  }
}

prinet_names = [ "prinetaz1-1", "prinetaz1-2", "prinetaz2-1", "prinetaz2-2" ]

prinet_specs = {
  "prinetaz1-1" = {
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-southeast-1a"
    az = "az1"
    desc = "private subnet 1 in AZ1"
  },
  "prinetaz1-2" = {
    cidr_block = "192.168.2.0/24"
    availability_zone = "ap-southeast-1a"
    az = "az1"
    desc = "private subnet 2 in AZ1"
  },
  "prinetaz2-1" = {
    cidr_block = "192.168.65.0/24"
    availability_zone = "ap-southeast-1b"
    az = "az2"
    desc = "private subnet 1 in AZ2"
  },
  "prinetaz2-2" = {
    cidr_block = "192.168.66.0/24"
    availability_zone = "ap-southeast-1b"
    az = "az2"
    desc = "private subnet 2 in AZ2"
  }
}

prinet_az = [ "prinetaz1-1", "prinetaz1-2", "prinetaz2-1", "prinetaz2-2" ]

prinet_desc = {
  "prinetaz1-1" = "AZ1"
  "prinetaz1-2" = "AZ1"
  "prinetaz2-1" = "AZ2"
  "prinetaz2-2" = "AZ2"
}
  
