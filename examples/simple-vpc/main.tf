
module "vpc" {
  source = "../../"

  tencentcloud_provider_region = "ap-shijiazhuang-ec"
  tags = {
    owner = "multi-cloud"
  }

  vpc_name = "test-vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_is_multicast = false

  enable_nat_gateway = false
  enable_route_table = false

  subnets = [
    {
      subnet_name = "review"
      subnet_cidr = "10.0.0.0/24"
      availability_zone = "ap-shijiazhuang-ec-1"
    },
    {
      subnet_name = "mall"
      subnet_cidr = "10.0.1.0/24"
      availability_zone = "ap-shijiazhuang-ec-1"
    }
  ]

}
