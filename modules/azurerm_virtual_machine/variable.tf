variable "nic_name" {
  description = "name of the nic"
  type = string
}
variable "location" {
  description = "location of the rg"
  type = string
}
variable "resource_group_name" {
  description = "name of the resource group"
  type = string 
}
variable "vm_name" {
  description = "name of the virtual machine"
  type = string
}
variable "image_publisher" {
  description = "publisher of the image"
  type = string
  default     = "Canonical"
}
variable "image_offer" {
  description = "offer of the image"
  type = string
  default     = "0001-com-ubuntu-server-jammy"
}
variable "image_sku" {
  description = "sku of the image"
  type = string
  default     = "22_04-lts"
}
variable "subnet_id" {
  description = "ID of the subnet where the VM will be deployed"
  type        = string
}
variable "pip_id" {
  description = "ID of the public IP address associated with the VM"
  type        = string
}