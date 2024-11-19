
#####___MAQUINES____####

# Data sources to get the existing images information
data "openstack_images_image_v2" "jammy" {
name = "jammy-server-cloudimg-amd64-vnx"
}

# Data sources to get the existing flavours information
data "openstack_compute_flavor_v2" "m1-smaller" {
    name = "m1.smaller"
}

# Data sources to get the existing network information
data "openstack_networking_network_v2" "net1" {
    name = "net1"
}

# Data sources to get the existing network information
data "openstack_networking_network_v2" "net2" {
    name = "net2"
}



#####___SERVERS____####
# VM servidores
resource "openstack_compute_instance_v2" "server" {
    count = 3
    name = "S${count.index + 1}"
    image_name = data.openstack_images_image_v2.jammy.name
    flavor_name = data.openstack_compute_flavor_v2.m1-smaller.name
    network {
        uuid = data.openstack_networking_network_v2.net1.id
    }
    network {
        uuid = data.openstack_networking_network_v2.net2.id
    }
    security_groups = [openstack_networking_secgroup_v2.my_security_group.name]

    user_data = file("./Modulos/Servers/CloudInit/cloud-init-server.yml")
}


# VM BBDD

resource "openstack_compute_instance_v2" "db" {
  name            = "DB"
  image_name      = "jammy-server-cloudimg-amd64-vnx"
  flavor_name     = "m1.smaller"
  network {
        uuid = data.openstack_networking_network_v2.net2.id
    }
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]

  user_data = file("./Modulos/Servers/CloudInit/cloud-init-db.yml")
}
