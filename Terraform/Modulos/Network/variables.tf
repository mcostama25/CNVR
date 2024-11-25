variable "ExtNet" {
  type    = string
  default = "ExtNet"
}

variable "nombre_red1"{
    description = "Nombre de la red"
    type = string
}

variable "nombre_subred1"{
    description = "Nombre de la subred"
    type = string
}

variable "nombre_red2"{
    description = "Nombre de la red"
    type = string
}

variable "nombre_subred2"{
    description = "Nombre de la subred"
    type = string
}

variable "admin_fixed_ip"{
  description = "Ip fija del ADMIN"
  type = string
  default = "10.1.1.100"
} 

variable "LB_ip" {
  description = "IP de acceso al LB"
  type = string
  default = "10.1.1.10"
}

variable "R1_ip" {
  description = "IP del router R1"
  type = string
  default = "10.1.1.1"
}