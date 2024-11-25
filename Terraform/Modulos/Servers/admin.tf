#####___ADMIN____####
# ExtNet
data "openstack_networking_network_v2" "ExtNet"{
  name = var.ExtNet
} 

# vm ADMIN
resource "openstack_compute_instance_v2" "admin" {
  name            = "Admin"
  image_name      = data.openstack_images_image_v2.jammy.name
  flavor_name     = data.openstack_compute_flavor_v2.m1-smaller.name
  key_pair    = openstack_compute_keypair_v2.user_key.name
  network {
      port = openstack_networking_port_v2.admin_port.id
  }
  network {
      uuid = var.net2_id
  }
  user_data = file("./Modulos/Servers/CloudInit/cloud-init-admin.yml")
}

# Create network port
resource "openstack_networking_port_v2" "admin_port" {
  name           = "admin_port"
  network_id     = var.net1_id
  admin_state_up = true
  security_group_ids = [
    openstack_compute_secgroup_v2.ssh.id,
    openstack_networking_secgroup_v2.my_security_group.id,
  ]
  fixed_ip {
    subnet_id = var.subnet1_id
    ip_address = var.admin_fixed_ip
  }
}


# floating ip
resource "openstack_networking_floatingip_v2" "floatIp_Admin" {
  pool = var.ExtNet
  address = var.admin_ip
}

# Asignar la IP flotante a la máquina virtual
resource "openstack_networking_floatingip_associate_v2" "floatIp_ass" {
    floating_ip = openstack_networking_floatingip_v2.floatIp_Admin.address
    port_id = openstack_networking_port_v2.admin_port.id
}


####____SECURiTY GROUP SSH____####
resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "Open input ssh port"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}



####____SSH____####
resource "openstack_compute_keypair_v2" "user_key" {
  name       = "user-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjwHRdOm/aWC0VuVHxZ+DkHJ37YQ9k1HZFxtBRnzbLLechsW5emOo6CTT0IjQ3KEvbuik/Iw9z6blo663lMAxUAE4FPWldWVjl2d5ZjPMqUyVS+2EeRLyi8+U4hkEF9lJvL8p/MLV6y1g1PxcCBOd3YOL6jmNRYRRRsbIrVUhx/YsqwJ7MAYSCCkwqE1hTLL52THeXaToE/ORuVOFbSmPrt07Hb924MeCPYN/+tPtgH3WMlZ8nGDScZyYrmfI64dw2YDtOzTeFLKEx7jxfJv/dvqGtEwf7Gq0i6TOwFFqKKW5B+NNTIBMuFY12Zbqt16+pCKijVAJ7+Flu5Ek3b855"
}