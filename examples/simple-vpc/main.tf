module "vpc" {
  source = "../../"

  vpc_name = "simple-vpc"
  vpc_cidr = "10.0.0.0/16"

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["10.0.0.0/24"]

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["EIP"]
  next_hub          = ["0"]

  acl_name = "test_acl"
  ingress  = ["ACCEPT#192.168.1.0/24#800#TCP", "ACCEPT#192.168.1.0/24#800-900#TCP",]
  egress   = ["ACCEPT#192.168.1.0/24#800#TCP", "ACCEPT#192.168.1.0/24#800-900#TCP",]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    test = "vpc"
  }

  subnet_tags = {
    test = "subnet"
  }
}
