
# outputs

output "network1_id"{
   value = openstack_networking_network_v2.net1.id
}

output "network2_id"{
   value = openstack_networking_network_v2.net2.id
}

output "subnet1_id"{
   value = openstack_networking_subnet_v2.subnet1.id
}

output "subnet2_id"{
   value = openstack_networking_subnet_v2.subnet2.id
}
