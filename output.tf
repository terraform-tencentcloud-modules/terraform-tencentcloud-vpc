
output vpc_id {
  value = local.vpc_id
}

output "subnets" {
  value = local.subnet_name_to_id
}
//
//output "subnet_id" {
//  value = local.subnet_id_map
//}

output "rtbs" {
  value = local.route_table_name_to_id
}

output "nat" {
  value = local.nat_gateway_name_to_id
}

output "default_rtb" {
  value = local.default_rtb_after
}