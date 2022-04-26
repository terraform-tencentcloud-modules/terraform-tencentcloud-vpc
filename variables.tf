variable "region" {
  default = "ap-hangzhou-ec"
}

variable "vpc_id" {
  description = "The vpc id used to launch resources."
  default     = ""
}

variable "vpc_name" {
  description = "The vpc name used to launch a new vpc when 'vpc_id' is not specified."
  default     = "tf-modules-vpc"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default     = "172.16.0.0/16"
}

variable "vpc_is_multicast" {
  description = "Specify the vpc is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "vpc_dns_servers" {
  description = "Specify the vpc dns servers when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "vpc_tags" {
  description = "Additional tags for the vpc."
  type        = map(string)
  default     = {}
}

variable subnets {
  type = list(object({
    subnet_name = string
    subnet_cidr = string
    route_table_name = optional(string)
//    is_multicast = optional(string)   # subnet's is_multicast must be the same with VPC's.
    availability_zone = string
    tags = optional(map(string))
  }))

  default = []
}

# route table
variable "enable_route_table" {
  description = "Should be true if you want to provision route tables for each of your private networks"
  type        = bool
  default     = false
}
variable "route_table_name_to_id" {
  description = "If enable_route_table is false, you need to provide the existing route_table_ids. It is used when you import existing resources and do not manage route table"
  # {"rtb_name" => "rtb_id" }
  type = map(string)
  default = {}
}
variable "default_route_table_dest_to_hub" {
  type = map(string)
  # 目标CIDR           下一跳
  # 自动根据下一跳识别下一跳类型：
  # 如果下一跳：
  #   是0，       则下一跳类型为 EIP
  #   是IP地址，   则下一跳类型为 NORMAL_CVM
  #   以pcx开头，  则下一跳类型为 PEERCONNECTION
  #   以dcg开头，  则下一跳类型为 DIRECTCONNECT
  #   以vpngw开头，则下一跳类型为 VPN
  default = {}
}
variable "default_route_table_attach_nat_gateway" {
  type = bool
  default = false
}
variable "default_route_table_nat_gateway_name" {
  type = string
  default = "" # this value must be set when default_route_table_attach_nat_gateway is true and exist in nat-gateways
}
variable "default_route_table_nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route."
  type        = string
  default     = "0.0.0.0/0"
}

variable route_tables {
  type = list(object({
    route_table_name = string
    dest_to_hub = map(string)
    # 目标CIDR           下一跳
    # 自动根据下一跳识别下一跳类型：
    # 如果下一跳：
    #   是0，       则下一跳类型为 EIP
    #   是IP地址，   则下一跳类型为 NORMAL_CVM
    #   以pcx开头，  则下一跳类型为 PEERCONNECTION
    #   以dcg开头，  则下一跳类型为 DIRECTCONNECT
    #   以vpngw开头，则下一跳类型为 VPN
    attach_nat_gateway = bool
    nat_gateway_name = optional(string) # if attach_nat_gateway is true, this value must be set and exist in nat-gateways
    nat_gateway_destination_cidr_block = optional(string)
  }))
  default = []
}

# nat gateway
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "nat_gateway_name_to_id" {
  description = "If enable_nat_gateway is false, you need to provide the existing nat_gateway_id. It is used when you import existing resources and do not manage nat gateway"
  type = map(string)
  default = {}
}

variable nat_gateways {
  type = list(object({
    nat_name = string
    bandwidth = optional(number)
    max_concurrent = optional(number)
    eips = list(object({
      internet_charge_type = optional(string)
      internet_max_bandwidth_out = optional(number)
      internet_service_provider = optional(string)
    }))
    tags = optional(map(string))
  }))
  default = []
}

variable "nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  type = map(string)
  default = {}
}