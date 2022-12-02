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

  network_acl_tags = {
    test = "acl"
  }

  manage_network_acl  = true
  network_acl_name    = "test-acl"
  network_acl_egress  = ["ACCEPT#10.0.0.0/8#ALL#TCP", "ACCEPT#9.0.0.0/8#ALL#TCP"]
  network_acl_ingress = ["ACCEPT#10.0.0.0/8#ALL#TCP"]
}
