variable "cidr_block" {
    default     = "10.0.0.0/16"
    description = "cidr block address"

}

variable "environment" {
    default = "test_environment"
}

variable "route_public_cidr_block" {
    default = "0.0.0.0/0"
}

variable "public_cidr_block" {
    type    = list(string)
    default = ["10.0.100.0/24", "10.0.200.0/24"]
}

variable "private_cidr_block" {
    type    = list(string)
    default = ["10.0.110.0/24","10.0.210.0/24"]
}

variable "public_count" {
    default = "2"
    type = string
}

variable "private_count" {
    default = "1"
    type = string
}

#bastion ip (for access)
variable "bastion_ip" {
    default = ["176.36.140.253/32"]
}
