### LOAD BALANCER

# create instance of the LB
resource "openstack_lb_loadbalancer_v2" "LB" {
  name = "LoadBalancer"
  # vip_subnet_id = var.subnet1_id
  # vip_address = var.LB_ip
  vip_port_id = openstack_networking_port_v2.LB_port.id
}

# create listener
resource "openstack_lb_listener_v2" "LB" {
  name            = "listener_LB"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.LB.id
  depends_on      = [openstack_lb_loadbalancer_v2.LB]
}

# Set loadbalancer pool
resource "openstack_lb_pool_v2" "LB" {
  name        = "pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.LB.id
  depends_on  = [openstack_lb_listener_v2.LB]
}

# Add multip instances to pool
resource "openstack_lb_member_v2" "servers" {
  count         = length(var.server_ips)
  address       = var.server_ips[count.index]
  protocol_port = 80
  pool_id       = openstack_lb_pool_v2.LB.id
  subnet_id     = var.subnet1_id
}


# IP flotante
# Create network port
resource "openstack_networking_port_v2" "LB_port" {
  name           = "LB_port"
  network_id     = var.net1_id
  admin_state_up = true
  security_group_ids = [
    openstack_networking_secgroup_v2.my_security_group.id,
  ]
  fixed_ip {
    subnet_id = var.subnet1_id
    ip_address = var.LB_ip
  }
}


# floating ip
resource "openstack_networking_floatingip_v2" "floatIp_LB" {
  pool = var.ExtNet
  address = var.LB_floatIP
}

# Asignar la IP flotante a la máquina virtual
resource "openstack_networking_floatingip_associate_v2" "LB_floatIp_ass" {
    floating_ip = openstack_networking_floatingip_v2.floatIp_LB.address
    port_id = openstack_networking_port_v2.LB_port.id
}
