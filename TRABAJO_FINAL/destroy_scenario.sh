#!/bin/bash

source /mnt/tmp/openstack_lab-antelope_4n_classic_ovs-v04/bin/admin-openrc.sh # permisos de root

# Eliminar máquinas virtuales
echo "Eliminando máquinas virtuales..."
for vm in $(openstack server list -f value -c ID); do
    openstack server delete $vm 2&>/dev/null
done

# Esperar a que se eliminen las máquinas virtuales
echo "Esperando a que se eliminen las máquinas virtuales..."
while openstack server list -f value -c ID | grep -q .; do 2&>/dev/null
    sleep 2
done

# Desconectando subredes
echo "Desconectando subredes"
for router in $(openstack router list -f value -c ID); do
	for subnet in $(openstack subnet list -f value -c ID); do
		openstack router remove subnet $router $subnet 2&>/dev/null
	done
done

# Cerrando gateways
echo "Cerrando gatewaus de los routers"
for router in $(openstack router list -f value -c ID); do
	openstack router unset --external-gateway $router 2&>/dev/null
done
	
# Eliminar routers
echo "Eliminando routers..."
for router in $(openstack router list -f value -c ID); do
	openstack router delete $router 2&>/dev/null
done

# Eliminar subredes
echo "Eliminando subredes..."
for subnet in $(openstack subnet list -f value -c ID); do
    openstack subnet delete $subnet 2&>/dev/null
done

# Eliminar redes
echo "Eliminando redes..."
for network in $(openstack network list -f value -c ID); do
    openstack network delete $network 2&>/dev/null
done

echo "Eliminación completa."
