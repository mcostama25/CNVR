#!/bin/bash
#/lab/cnvr/bin/get-openstack-tutorial.sh

#sudo vnx -f /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/openstack_lab.xml -v --create
#sudo vnx -f /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/openstack_lab.xml -v -x start-all,load-img

source /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/bin/admin-openrc.sh # permisos de root

 # Create security group rules to allow ICMP, SSH and WWW access
admin_project_id=$(openstack project show admin -c id -f value)
default_secgroup_id=$(openstack security group list -f value | grep default | grep $admin_project_id | cut -d " " -f1)
openstack security group rule create --proto icmp --dst-port 0  $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 80 $default_secgroup_id
openstack security group rule create --proto tcp  --dst-port 22 $default_secgroup_id

# Create internal network
openstack network create net1
openstack subnet create --network net1 --gateway 10.1.10.1 --dns-nameserver 8.8.8.8 --subnet-range 10.1.10.0/24 --allocation-pool start=10.1.10.8,end=10.1.10.100 subnet1

openstack network create net2
openstack subnet create --network net2 --gateway 10.1.20.1 --dns-nameserver 8.8.8.8 --subnet-range 10.1.20.0/24 --allocation-pool start=10.1.20.8,end=10.1.20.100 subnet2


# Create virtual machines
mkdir -p ./keys
for i in {1..6};do
	openstack keypair create vm$i > ./keys/vm$i
done
chmod 600 ./keys/vm*

# we put machines 1 2 3 to subnet net1
for i in {1..3};do
	openstack server create --flavor m1.tiny --image cirros-0.3.4-x86_64-vnx vm$i --nic net-id=net1 --key-name vm$i
done

for i in {4..6};do
	openstack server create --flavor m1.tiny --image cirros-0.3.4-x86_64-vnx vm$i --nic net-id=net2 --key-name vm$i
done

# Create external network 
openstack router create r0
openstack router set r0 --external-gateway ExtNet
openstack router add subnet r0 subnet1
openstack router add subnet r0 subnet2

# Assign floating IP address to vms
for i in {1..6}; do
	openstack server add floating ip vm$i $( openstack floating ip create ExtNet -c floating_ip_address -f value )
done
