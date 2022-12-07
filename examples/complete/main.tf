variable "availability_zones" {
  type    = list(string)
  default = ["ap-guangzhou-7", "ap-guangzhou-6"]
}

module "vpc" {
  source   = "../../"
  vpc_name = "complete-vpc"
  vpc_cidr = "10.0.0.0/16"

  enable_vpn_gateway = true
  availability_zones = var.availability_zones

  create_route_table = true
  destination_cidrs  = ["10.1.0.0/16"]
  next_type          = ["VPN"]
  next_hub           = ["0"]

  tags = {
    module = "my-cluster"
  }
}

module "public_subnet" {
  source             = "../../"
  create_vpc         = false
  vpc_id             = module.vpc.vpc_id
  tags               = module.vpc.tags
  availability_zones = var.availability_zones

  subnet_name  = "public"
  subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]

  create_route_table = true
  destination_cidrs  = ["10.1.0.0/16", "0.0.0.0/0"]
  next_type          = ["VPN", "NAT"]
  next_hub           = [module.vpc.vpn_gateway_id, "0"]

  enable_nat_gateway = true

  manage_network_acl  = true
  network_acl_name    = "public"
  network_acl_ingress = ["ACCEPT#0.0.0.0/0#80#TCP", "ACCEPT#0.0.0.0/0#443#TCP", "ACCEPT#10.0.0.0/8#ALL#ALL"]
  network_acl_egress  = ["ACCEPT#0.0.0.0/0#ALL#ALL"]
}

module "intranet_subnet" {
  source     = "../../"
  create_vpc = false
  vpc_id     = module.vpc.vpc_id
  tags       = module.vpc.tags

  subnet_name        = "intranet"
  availability_zones = var.availability_zones
  subnet_cidrs       = ["10.0.4.0/24", "10.0.5.0/24"]

  manage_network_acl  = true
  network_acl_ingress = ["ACCEPT#10.0.0.0/8#ALL#ALL"]
  network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#ALL"]
}


module "database_subnet" {
  source     = "../../"
  create_vpc = false
  vpc_id     = module.vpc.vpc_id
  tags       = module.vpc.tags

  subnet_name        = "database"
  availability_zones = var.availability_zones
  subnet_cidrs       = ["10.0.6.0/24", "10.0.7.0/24"]

  manage_network_acl  = true
  network_acl_ingress = ["ACCEPT#10.0.0.0/8#3306#TCP"]
  network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#TCP"]
}
