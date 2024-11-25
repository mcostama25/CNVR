# main.tf
module "networks" {
  source = "./Modulos/Network"
  providers = {
        openstack = openstack
    }
  nombre_red1 = "Net1"
  nombre_red2 = "Net2"
  nombre_subred1 = "red_Servers"
  nombre_subred2 = "red_BBDD"
}

module "servers" {
  source = "./Modulos/Servers"
  providers = {
        openstack = openstack
    }
  ExtNet = var.ExtNet
  net1_id = module.networks.network1_id
  net2_id = module.networks.network2_id
  subnet1_id = module.networks.subnet1_id
  subnet2_id = module.networks.subnet2_id
  server_ips = module.servers.server_ips

  depends_on = [module.networks]
}