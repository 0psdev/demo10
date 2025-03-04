rsg_names = "rsg_01"

location_names = "southeastasia"

storage_account_name = "strdiagvm"

vnet_name = "vnet_01"

vnet_subnet = ["192.168.0.0/17"]

snet_names = ["subnet_01", "subnet_02", "subnet_03"]

snet_subnets = {
    "subnet_01" = ["192.168.0.0/24"],
    "subnet_02" = ["192.168.1.0/24"],
    "subnet_03" = ["192.168.2.0/24"]
}

public_ip_name ="pip"

natgw_name = "ngw"

vm_names = [ "vm01", "vm02", "vm03", "vm04" ]

vm_specs = {
  "vm01" = {
    vm_size = "Standard_B1s"
    zone    = "1"
    subnet = "subnet_02"
  },
  "vm02" = {
    vm_size = "Standard_B1s"
    zone    = "1"
    subnet = "subnet_03"
  },
    "vm03" = {
    vm_size = "Standard_B1s"
    zone = "2"
    subnet = "subnet_02"
  },
    "vm04" = {
    vm_size = "Standard_B1s"
    zone = "2"
    subnet = "subnet_03"
  }
}
