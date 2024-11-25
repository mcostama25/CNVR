variable "ExtNet" {
  type    = string
  default = "ExtNet"
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

variable "server_ips" {
    description = "IPs asignades al los servidores wweb"
    type = list(string)
}

variable "LB_ip" {
  description = "IP de acceso al LB"
  type = string
  default = "10.1.1.10"
}

variable "LB_floatIP" {
  description = "IP flotante LB"
  type = string
  default = "10.0.10.10"
}

variable "admin_ip" {
  description = "Ip de acceso ssh a ADMIN"
  type = string
  default = "10.0.10.200"
}

