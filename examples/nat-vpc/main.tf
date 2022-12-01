module "vpc" {
  source             = "../../"
  vpc_name           = "simple-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-guangzhou-7", "ap-guangzhou-6"]

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["EIP"]
  next_hub          = ["0"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }
}

module "nat_subnet" {
  source             = "../../"
  create_vpc         = false
  vpc_id             = module.vpc.vpc_id
  create_route_table = true
  availability_zones = ["ap-guangzhou-7", "ap-guangzhou-6"]

  subnet_name  = "nat"
  subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]

  destination_cidrs = ["0.0.0.0/0"]
  next_type         = ["NAT"]
  next_hub          = [null]

  tags               = module.vpc.tags
  enable_nat_gateway = true
}
