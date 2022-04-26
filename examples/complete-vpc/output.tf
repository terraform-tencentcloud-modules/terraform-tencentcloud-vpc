
output "vpc" {
  value = module.vpc.vpc
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_gateway" {
  value = module.vpc.nat
}

output "route_tables" {
  value = module.vpc.rtbs
}

output "subnets" {
  value = module.vpc.subnets
}