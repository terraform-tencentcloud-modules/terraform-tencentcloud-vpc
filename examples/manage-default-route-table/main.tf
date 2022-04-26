provider tencentcloud {
  region = "ap-shijiazhuang-ec"
}

module "vpc" {
  source = "../../"

  region = "ap-shijiazhuang-ec"
  tags = {
    owner = "multi-cloud"
  }

  vpc_name = "test-vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_is_multicast = false

  enable_nat_gateway = true
  nat_gateways =[
    {
      nat_name = "nat-1",
      eips = [
        {
          internet_max_bandwidth_out = 10
          internet_service_provider = "CMCC"
        }
      ]
    }
  ]
  enable_route_table = true
  default_route_table_dest_to_hub = {
    "1.2.3.0/24": "0"
  }
  default_route_table_attach_nat_gateway = true
  default_route_table_nat_gateway_name = "nat-1"

  subnets = [
    {
      subnet_name = "review"
      subnet_cidr = "10.0.128.0/24"
      availability_zone = "ap-shijiazhuang-ec-1"
    }
  ]

}

