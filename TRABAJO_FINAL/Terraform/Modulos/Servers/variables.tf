variable "ExtNet" {
  type    = string
  default = "external-network"
}

variable "external_gateway" {
  type    = string
    default = "3613b4a7-7c97-43b4-aec2-7591e1e3b00c"
}

variable "net1_id"{
    description = "Id de la red"
    type = string
}

variable "net2_id"{
    description = "Id de la red"
    type = string
}

variable "subnet1_id"{
    description = "Id de la red"
    type = string
}

variable "subnet2_id"{
    description = "Id de la subred"
    type = string
}

