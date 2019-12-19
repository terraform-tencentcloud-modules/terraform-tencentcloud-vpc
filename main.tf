provider "tencentcloud" {
  version = ">=1.18.1"
  region  = var.region != "" ? var.region : null
}

data "tencentcloud_instance_types" "default" {
  cpu_core_count = var.cpu_core_count
  gpu_core_count = var.gpu_core_count
  memory_size    = var.memory_size
}

resource "tencentcloud_vpc" "vpc" {
  count        = var.vpc_id == "" ? 1 : 0
  name         = var.vpc_name
  cidr_block   = var.vpc_cidr
  is_multicast = var.vpc_is_multicast
  dns_servers  = length(var.vpc_dns_servers) > 0 ? var.vpc_dns_servers : null
  tags         = merge(var.tags, var.vpc_tags)
}

resource "tencentcloud_subnet" "subnet" {
  count             = length(var.subnet_cidrs)
  name              = length(var.subnet_cidrs) < 2 ? var.subnet_name : format("%s_%s", var.subnet_name, format(var.number_format, count.index + 1))
  vpc_id            = var.vpc_id != "" ? var.vpc_id : tencentcloud_vpc.vpc[0].id
  cidr_block        = var.subnet_cidrs[count.index]
  is_multicast      = var.subnet_is_multicast
  availability_zone = length(var.availability_zones) > 0 ? var.availability_zones[count.index] : lookup(data.tencentcloud_instance_types.default.instance_types[format("%d", length(data.tencentcloud_instance_types.default.instance_types) < 2 ? 0 : count.index % length(data.tencentcloud_instance_types.default.instance_types))], "availability_zone")
  tags              = merge(var.tags, var.subnet_tags)
}

resource "tencentcloud_route_table_entry" "route_entry" {
  count                  = length(var.destination_cidrs)
  route_table_id         = var.route_table_id != "" ? var.route_table_id : tencentcloud_subnet.subnet[0].route_table_id
  destination_cidr_block = var.destination_cidrs[count.index]
  next_type              = var.next_type[count.index]
  next_hub               = var.next_hub[count.index]
}
