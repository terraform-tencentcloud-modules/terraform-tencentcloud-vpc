output "vpc_id" {
  description = "The id of vpc."
  value       = module.nat_subnet.vpc_id
}

output "subnet_id" {
  description = "The id of subnet."
  value       = module.nat_subnet.subnet_id
}

output "route_table_id" {
  description = "The id of route table."
  value       = module.nat_subnet.route_table_id
}

output "route_entry_id" {
  description = "The id of route table entry."
  value       = module.nat_subnet.route_entry_id
}

output "nat_gateway_id" {
  description = "The id of route table entry."
  value       = module.nat_subnet.nat_gateway_id
}


