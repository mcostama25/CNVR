# ExtNet
data "openstack_networking_network_v2" "ExtNet"{
    name = var.ExtNet
} 

# Router creation
resource "openstack_networking_router_v2" "R1" {
  name = "router"
  external_network_id = data.openstack_networking_network_v2.ExtNet.id
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "R1_interface" {
  router_id = openstack_networking_router_v2.R1.id
 # subnet_id = openstack_networking_subnet_v2.subnet1.id
  port_id = openstack_networking_port_v2.R1_port.id
} 

# Puerto apra el router y el FW
resource "openstack_networking_port_v2" "R1_port" {
  network_id = openstack_networking_network_v2.net1.id
  fixed_ip{
    subnet_id = openstack_networking_subnet_v2.subnet1.id
    ip_address = var.R1_ip
  } 
  admin_state_up = true
}

# network 1
resource "openstack_networking_network_v2" "net1" {
    name = var.nombre_red1
}

# subnetwork 1
resource "openstack_networking_subnet_v2" "subnet1" {
    name = var.nombre_subred1
    network_id = openstack_networking_network_v2.net1.id
    cidr = "10.1.1.0/24"
    ip_version = 4
    dns_nameservers = ["8.8.8.8"]
    gateway_ip = "10.1.1.1"
    allocation_pool {
        start = "10.1.1.2"
        end = "10.1.1.100"
    }
}


# network 2
resource "openstack_networking_network_v2" "net2" {
    name = var.nombre_red2
}

# subnetwork 2
resource "openstack_networking_subnet_v2" "subnet2" {
    name = var.nombre_subred2
    network_id = openstack_networking_network_v2.net2.id
    cidr = "10.1.2.0/24"
    ip_version = 4
    dns_nameservers = ["8.8.8.8"]
    gateway_ip = "10.1.2.1"
    allocation_pool {
        start = "10.1.2.2"
        end = "10.1.2.100"
    }
}

