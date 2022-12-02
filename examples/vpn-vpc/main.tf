module "vpc" {
  source             = "../../"
  vpc_name           = "simple-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-guangzhou-7", "ap-guangzhou-6"]

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["VPN"]
  next_hub          = ["0"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }

  vpn_gateway_tags = {
    test = "vpn"
  }

  enable_vpn_gateway = true
}
