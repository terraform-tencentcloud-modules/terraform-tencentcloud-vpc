output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = module.vpc.subnets
}

output "default_rtb" {
  value = module.vpc.default_rtb
}