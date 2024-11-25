# reglas
resource "openstack_fw_rule_v2" "ssh_rule" {
  name             = "firewall_rule_1"
  description      = "permit ssh to port 2022"
  action           = "allow"
  protocol         = "tcp"
  source_ip_address = "0.0.0.0/0"
  destination_ip_address = var.admin_fixed_ip
  destination_port = "2022"
  enabled          = "true"
}

resource "openstack_fw_rule_v2" "www_rule" {
  name             = "firewall_rule_2"
  description      = "permit traffic to servers"
  action           = "allow"
  protocol         = "tcp"
  source_ip_address = "0.0.0.0/0"
  destination_ip_address = var.LB_ip
  destination_port = "80"
  enabled          = "true"
}

resource "openstack_fw_rule_v2" "internal_rule" {
  name             = "firewall_rule_3"
  description      = "permit internal traffic"
  action           = "allow"
  protocol         = "any"
  source_ip_address = "10.1.1.0/24"
  destination_ip_address = "0.0.0.0/0"
  enabled          = "true"
}
# Politicas

resource "openstack_fw_policy_v2" "ingress" {
  name = "firewall_ingress_policy"

  rules = [
    openstack_fw_rule_v2.ssh_rule.id,
    openstack_fw_rule_v2.www_rule.id
  ]
}

resource "openstack_fw_policy_v2" "egress" {
  name = "firewall_egress_policy"

  rules = [
    openstack_fw_rule_v2.internal_rule.id,
  ]
}

resource "openstack_fw_group_v2" "group_1" {
  name      = "firewall_group"
  ingress_firewall_policy_id = openstack_fw_policy_v2.ingress.id
  egress_firewall_policy_id = openstack_fw_policy_v2.egress.id

  ports =[
    openstack_networking_port_v2.R1_port.id
  ] 
}