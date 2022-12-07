data "tencentcloud_vpc_instances" "foo" {
  name = "Default-VPC"
}

module "vpc" {
  source     = "terraform-tencentcloud-modules/vpc/tencentcloud"
  create_vpc = false
  vpc_id     = data.tencentcloud_vpc_instances.foo.instance_list.0.vpc_id

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["172.16.64.0/20", "172.16.128.0/20"]

  destination_cidrs = ["14.0.1.0/24", "14.0.2.0/24"]
  next_type         = ["EIP", "EIP"]
  next_hub          = ["0", "0"]

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
