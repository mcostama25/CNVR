output "floating_ip"{
value = openstack_networking_floatingip_v2.floatIp_Admin.address
}

output "server_ips" {
  value = [
    for instance in openstack_compute_instance_v2.server : instance.access_ip_v4
  ]
}