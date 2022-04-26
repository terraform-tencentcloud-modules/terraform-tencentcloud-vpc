locals {
  assigned_eip_set = [ for eip in tencentcloud_eip.eips : eip.public_ip]
}

resource "tencentcloud_eip" "eips" {
  count                      = length(var.eips)
  internet_charge_type       = var.eips[count.index].internet_charge_type
  internet_max_bandwidth_out = var.eips[count.index].internet_max_bandwidth_out
  type                       = "EIP"
  internet_service_provider = var.eips[count.index].internet_service_provider
  tags = var.tags
}

resource "tencentcloud_nat_gateway" "nat" {
  name             = var.name
  vpc_id           = var.vpc_id
  bandwidth        = var.bandwidth
  max_concurrent   = var.max_concurrent
  assigned_eip_set = local.assigned_eip_set

  tags = var.tags
}

output "nat_name" {
  value = tencentcloud_nat_gateway.nat.name
}
output "nat_id" {
  value = tencentcloud_nat_gateway.nat.id
}