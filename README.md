# TencentCloud VPC Module for Terraform

## terraform-tencentcloud-vpc

A terraform module used to create TencentCloud VPC, subnet and route entry.

The following resources are included.

* [VPC](https://www.terraform.io/docs/providers/tencentcloud/r/vpc.html)
* [VPC Subnet](https://www.terraform.io/docs/providers/tencentcloud/r/subnet.html)
* [VPC Route Entry](https://www.terraform.io/docs/providers/tencentcloud/r/route_table_entry.html)

## Usage

```hcl
module "vpc" {
  source  = "terraform-tencentcloud-modules/vpc/tencentcloud"
  version = "1.0.3"

  vpc_name = "simple-vpc"
  vpc_cidr = "10.0.0.0/16"

  subnet_name  = "simple-vpc"
  subnet_cidrs = ["10.0.0.0/24"]

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["EIP"]
  next_hub          = ["0"]

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
```

## Conditional Creation

This module can create VPC and VPC Subnet.
It is possible to use existing VPC when specify `vpc_id` parameter.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | TencentCloud region to launch resources. | string | "" | no
| tags | A map of tags to add to all resources. | map(string) | {} | no
| cpu_core_count | CPU core count used to query supported available zones. | intger | 1 | no
| memory_size | Memory size used to query supported available zones. | intger | 2 | no
| gpu_core_count | GPU core count used to query supported available zones. | intger | 0 | no
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
