
data "tencentcloud_vpc_instances" "default" {
  name = "Default-VPC"
}

module "vpc" {
  source = "../../"

  tencentcloud_provider_region = "ap-shijiazhuang-ec"
  tags = {
    owner = "multi-cloud"
  }

  vpc_id = data.tencentcloud_vpc_instances.default.instance_list[0].vpc_id

  enable_nat_gateway = false
  enable_route_table = false

  subnets = [
    {
      subnet_name = "review"
      subnet_cidr = "10.215.128.0/24"
      availability_zone = "ap-shijiazhuang-ec-1"
    }
  ]

}

