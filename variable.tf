# A variables.tf file is used to define the variables and optionally set a default value

variable "rgname" {
  type        = string
  description = "trailrg"
  default     = "RG"
}

variable "rglocation" {
  type        = string
  description = "trailrg"
  default     = "eastus"
}

variable "vnetname" {
  type        = string
  description = "trailvn"
  default     = "vnet1"
}

variable "subnetname" {
  type        = string
  description = "trailsb"
  default     = "subnet1"
}

variable "vmname" {
  type        = string
  description = "trailvm"
  default     = "vm1"
}

variable "vnet_ip_address_space" {
  type        = string
  description = "IP address space of the vnet"
  default     = "10.0.0.0/16"
}

variable "subnet_ip_address_prefix" {
  type        = string
  description = "IP address prefix of the subnet"
  default     = "10.0.0.0/24"
}

variable "vm_public_ip" {
  type        = string
  description = "trailpublicip"
  default     = "vmip"
}

variable "privatenic" {
  type        = string
  description = "trailprivateip"
  default     = "vmprivateip"
}

variable "vmsize" {
  type        = string
  description = "name of the vm size"
  default     = "Standard_DS1_v2"
}

variable "manageddiskname" {
  type        = string
  description = "name of the datadiskname"
  default     = "mdisk"
}

variable "nsg" {
  type        = string
  description = "name of the nsgrule"
  default     = "nsg1"
}

variable "username" {
  type        = string
  description = "user name of the vm"
  default     = "veeresh"
}

variable "pswd" {
  type        = string
  description = "pswd ame of the vm"
  default     = "mayuveeru@143"
}
