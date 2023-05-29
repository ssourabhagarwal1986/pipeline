variable "location" {
    default = "eastus"
  
}
  
variable "virtualnetwork" {
  default = "sourabhvirtualnetwork"
  description = "this is sourabh virtual network"

}

variable "tags" {
default = {
    test = "sourabh resource"
    environment = "UAT"
}  
}

variable "instanceCount" {
  description = "Please enter the number of instance needs to be created"
}