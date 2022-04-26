# TencentCloud VPC Module for Terraform

## terraform-tencentcloud-vpc

A terraform module used to create TencentCloud VPC, nat-gateway, subnet, route table and routes entry.

The following resources included.

* [VPC](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/vpc)
* [VPC Subnet](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/subnet)
* [VPC Nat Gateway](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/nat_gateway)
* [VPC Route Table](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table)
* [VPC Route Entry](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/route_table_entry)

## Usage

```hcl
module "vpc" {
  source = "terraform-tencentcloud-modules/vpc/tencentcloud"

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
    },
    {
      nat_name = "nat-2"
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
  default_route_table_nat_gateway_name = "nat-2"
  route_tables = [
    {
      route_table_name = "rtb-1",
      dest_to_hub = {}
      attach_nat_gateway = true
      nat_gateway_name = "nat-1"
    },
    {
      route_table_name = "rtb-2",
      dest_to_hub = {
        "5.6.7.0/24": "0"
      }
      attach_nat_gateway = false
    }
  ]

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
      route_table_name = "rtb-2"
    }
  ]
}

```

## Conditional Creation

This module can create VPC and VPC Subnet.
It is possible to use existing VPC when specify `vpc_id` parameter.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| tags | A map of tags to add to all resources. | map(string) | {} | no
| vpc_id | The vpc id used to launch resources. | string | "" | no
| vpc_name | The vpc name used to launch a new vpc when 'vpc_id' is not specified. | string | tf-modules-vpc | no
| vpc_cidr | The cidr block used to launch a new vpc when 'vpc_id' is not specified. | string | 172.16.0.0/16 | no
| vpc_is_multicast | Specify the vpc is multicast when 'vpc_id' is not specified. | bool | true | no
| vpc_dns_servers | Specify the vpc dns servers when 'vpc_id' is not specified. | list(string) | [] | no
| vpc_tags | Additional tags for the vpc. | map(string) | {} | no
| subnet_name | Specify the subnet name when 'vpc_id' is not specified. | string | tf-modules-subnet | no
| subnet_cidrs | Specify the subnet cidr blocks when 'vpc_id' is not specified. | list(string) | [] | no
| subnet_is_multicast | Specify the subnet is multicast when 'vpc_id' is not specified. | bool | true | no
| subnet_tags | Additional tags for the subnet. | map(string) | {} | no
| availability_zones | List of available zones to launch resources. | list(string) | [] | no
| route_table_id | The route table id of router table in the specified vpc. | string | "" | no
| destination_cidrs | List of destination CIDR blocks of router table in the specified VPC. | list(string) | [] | no
| next_type | List of next hop types of router table in the specified vpc. | list(string) | [] | no
| next_hub | List of next hop gateway id of router table in the specified vpc. | list(string) | [] | no

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The id of vpc. |
| subnet_id | The id of subnet. |
| route_table_id | The id of route table. |
| route_entry_id | The id of route table entry. |
| availability_zones | The availability zones of instance type. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
