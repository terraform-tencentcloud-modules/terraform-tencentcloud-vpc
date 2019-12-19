output "vpc_id" {
  description = "The id of vpc."
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The id of subnet."
  value       = module.vpc.subnet_id
}

output "route_table_id" {
  description = "The id of route table."
  value       = module.vpc.route_table_id
}

output "route_entry_id" {
  description = "The id of route table entry."
  value       = module.vpc.route_entry_id
}
