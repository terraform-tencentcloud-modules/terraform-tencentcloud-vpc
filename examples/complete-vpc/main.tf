provider tencentcloud {
  region = "ap-shijiazhuang-ec"
}

module "vpc" {
  source = "../../"

  tags = {
    owner = "multi-cloud"
  }

  vpc_name = "test-vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_is_multicast = false

  enable_nat_gateway = true
  nat_gateways =[
    { nat_name = "nat-1", eips = [{ internet_max_bandwidth_out = 10, internet_service_provider = "CMCC" }] },
    { nat_name = "nat-2", eips = [{ internet_max_bandwidth_out = 10, internet_service_provider = "CMCC" }] }
  ]

  enable_route_table = true
  default_route_table_dest_to_hub = {
    "1.2.3.0/24": "0"
  }
  default_route_table_attach_nat_gateway = true
  default_route_table_nat_gateway_name = "nat-2"
  route_tables = [
    { route_table_name = "rtb-1", dest_to_hub = {}, attach_nat_gateway = true, nat_gateway_name = "nat-1" },
    { route_table_name = "rtb-2", dest_to_hub = { "5.6.7.0/24": "0" }, attach_nat_gateway = false }
  ]

  subnets = [
    { subnet_name = "review", subnet_cidr = "10.0.0.0/24", availability_zone = "ap-shijiazhuang-ec-1" },
    { subnet_name = "mall", subnet_cidr = "10.0.1.0/24", availability_zone = "ap-shijiazhuang-ec-1", route_table_name = "rtb-2" }
  ]
}
