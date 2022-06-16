
locals {
  # global
  tags = var.tags

  # vpc
  create_vpc = var.vpc_id == "" ? true: false
  vpc_id = local.create_vpc ? tencentcloud_vpc.vpc[0].id : var.vpc_id
  vpc = data.tencentcloud_vpc_instances.vpc.instance_list[0]
  vpc_is_multicast = local.vpc.is_multicast

  # nat gateway
  enable_nat_gateway = var.enable_nat_gateway
  nat_gateway_name_to_id = local.enable_nat_gateway ? { for nat in module.nats: nat.nat_name => nat.nat_id } : var.nat_gateway_name_to_id

  # route tables
  enable_route_table = var.enable_route_table
  default_rtb = [for rtb in data.tencentcloud_vpc_route_tables.rtbs.instance_list: rtb if rtb.is_default ][0]
  default_rtb_after = [for rtb in data.tencentcloud_vpc_route_tables.rtbs_after.instance_list: rtb if rtb.is_default ][0]
  route_table_name_to_id = local.enable_route_table ? { for rtb in tencentcloud_route_table.rtbs: rtb.name => rtb.id }: var.route_table_name_to_id

  # route table entries
  rtb_pfx_to_next_type = {
    "pcx" : "PEERCONNECTION",
    "dcg" : "DIRECTCONNECT",
    "vpngw" : "VPN",
    "nat" : "NAT",
    "0" : "EIP",
    "ccn": "CCN",
  }
  rtb_entry_list = flatten([
    for rtb in var.route_tables: [
      for destination_cidr_block, next_hub in rtb.dest_to_hub: {
        destination_cidr_block = destination_cidr_block
        next_hub = next_hub
        route_table_id = local.route_table_name_to_id[rtb.route_table_name]
      }
    ]
  ])
  default_rtb_entry_list = flatten([
    for destination_cidr_block, next_hub in var.default_route_table_dest_to_hub: {
      destination_cidr_block = destination_cidr_block
      next_hub = next_hub
    }
  ])
  public_entry_list = flatten([
    for rtb in var.route_tables: {
      route_table_id = local.route_table_name_to_id[rtb.route_table_name]
      destination_cidr_block = rtb.nat_gateway_destination_cidr_block == null || rtb.nat_gateway_destination_cidr_block == "" ? var.nat_gateway_destination_cidr_block : rtb.nat_gateway_destination_cidr_block
      next_hub = local.nat_gateway_name_to_id[rtb.nat_gateway_name]
  } if rtb.attach_nat_gateway
  ])

  # subnet
//  subnets = { for subnet in local.s : subnet.subnet_key => subnet }
//  created_subnets = { for name, subnet in module.subnet: name => subnet.subnet }
  subnet_name_to_id = { for subnet in tencentcloud_subnet.subnets: subnet.name => subnet.id }

}

# VPC
resource "tencentcloud_vpc" "vpc" {
  count        = local.create_vpc ? 1 : 0
  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  dns_servers  = length(var.vpc_dns_servers) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}
data "tencentcloud_vpc_instances" "vpc" {
  vpc_id = local.vpc_id
}

# Nat Gateway
module "nats" {
  count = length(var.nat_gateways)
  source = "./modules/nat-gateway"

  vpc_id = local.vpc_id
  name = var.nat_gateways[count.index].nat_name
  bandwidth = var.nat_gateways[count.index].bandwidth
  max_concurrent = var.nat_gateways[count.index].max_concurrent
  eips = var.nat_gateways[count.index].eips
  tags = merge(var.tags, var.nat_gateways[count.index].tags)
}

# route tables
resource "tencentcloud_route_table" "rtbs" {
  count = local.enable_route_table ? length(var.route_tables): 0
  name   = var.route_tables[count.index].route_table_name
  vpc_id = local.vpc_id
}
data "tencentcloud_vpc_route_tables" "rtbs" {
//  depends_on = [tencentcloud_route_table.rtbs]
  vpc_id = local.vpc_id
}
data "tencentcloud_vpc_route_tables" "rtbs_after" {
  depends_on = [tencentcloud_route_table_entry.default, tencentcloud_route_table_entry.default_public]
  vpc_id = local.vpc_id
}

# route table entries
resource "tencentcloud_route_table_entry" "entries" {
  count = local.enable_route_table ? length(local.rtb_entry_list): 0
  route_table_id         = local.rtb_entry_list[count.index].route_table_id
  destination_cidr_block = local.rtb_entry_list[count.index].destination_cidr_block
  next_type              = can(cidrnetmask(format("%s/%s", local.rtb_entry_list[count.index].next_hub, "32"))) ?  "NORMAL_CVM" : local.rtb_pfx_to_next_type[split("-", local.rtb_entry_list[count.index].next_hub)[0]]
  next_hub               = local.rtb_entry_list[count.index].next_hub
}
resource "tencentcloud_route_table_entry" "public_entries" {
  count = local.enable_route_table ? length(local.public_entry_list): 0
  route_table_id         = local.public_entry_list[count.index].route_table_id
  destination_cidr_block = local.public_entry_list[count.index].destination_cidr_block
  next_type              = "NAT"
  next_hub               = local.public_entry_list[count.index].next_hub
}
resource "tencentcloud_route_table_entry" "default" {
  count = local.enable_route_table ? length(local.default_rtb_entry_list): 0
  route_table_id         = local.default_rtb.route_table_id
  destination_cidr_block = local.default_rtb_entry_list[count.index].destination_cidr_block
  next_type              = can(cidrnetmask(format("%s/%s", local.default_rtb_entry_list[count.index].next_hub, "32"))) ?  "NORMAL_CVM" : local.rtb_pfx_to_next_type[split("-", local.default_rtb_entry_list[count.index].next_hub)[0]]
  next_hub               = local.default_rtb_entry_list[count.index].next_hub
}
resource "tencentcloud_route_table_entry" "default_public" {
  count = local.enable_route_table && var.default_route_table_attach_nat_gateway ? 1 : 0
  route_table_id         = local.default_rtb.route_table_id
  destination_cidr_block = var.default_route_table_nat_gateway_destination_cidr_block
  next_type              = "NAT"
  next_hub               = local.nat_gateway_name_to_id[var.default_route_table_nat_gateway_name]
}

# subnets
resource "tencentcloud_subnet" "subnets" {
  count = length(var.subnets)
  name              = var.subnets[count.index].subnet_name
  vpc_id            = local.vpc_id
  cidr_block        = var.subnets[count.index].subnet_cidr
  availability_zone = var.subnets[count.index].availability_zone
  route_table_id    = var.subnets[count.index].route_table_name == null || var.subnets[count.index].route_table_name == "" || var.subnets[count.index].route_table_name == "default" ? null: local.route_table_name_to_id[var.subnets[count.index].route_table_name]
  is_multicast      = local.vpc_is_multicast
  tags = merge(var.tags, var.subnets[count.index].tags)
}
