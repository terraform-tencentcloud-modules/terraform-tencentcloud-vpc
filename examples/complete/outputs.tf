output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.vpc_id
}

output "route_table_id" {
  description = "The id of route table."
  value       = module.vpc.route_table_id
}

output "vpn_gateway_id" {
  description = "The id of route table."
  value       = module.vpc.vpn_gateway_id
}


output "vpn_gateway_public_ip_address" {
  description = "The id of route table."
  value       = module.vpc.vpn_gateway_public_ip_address
}

output "nat_gateway_id" {
  description = "The id of route table entry."
  value       = module.public_subnet.nat_gateway_id
}

output "nat_public_ips" {
  value = module.public_subnet.nat_public_ips
}
