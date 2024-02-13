variable "rg_name" {
  type = string
  default     = "firewallrg"
}

variable "vnet_name" {
  default     = "WindowsVMVnet"
}
variable "vnet_cidr" {
  default     = ["10.0.0.0/16"]
}
variable "subnet_name" {
  default     = "WindowsVMSubnet"
}
variable "subnet_cidr" {
  default     = ["10.0.2.0/24"]
}
variable "network_interface_name" {
  default     = "WindowsVMNIC"
}
variable "nsg_name" {
  default     = "WindowsNSG"
}
variable "publicip_name" {
  default     = "WindowsVMPIP"
}
variable "vm_name" {
  default     = "WindowsVM-sample"
}
variable "admin_username" {
  default     = "Azureuser"
}
variable "admin_password" {
  default     = "Azure@123456789"
}
