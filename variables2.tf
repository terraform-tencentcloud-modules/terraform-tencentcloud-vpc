variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "cpu_core_count" {
  description = "CPU core count used to query supported available zones."
  default     = 1
}

variable "memory_size" {
  description = "Memory size used to query supported available zones."
  default     = 2
}

variable "gpu_core_count" {
  description = "GPU core count used to query supported available zones."
  default     = 0
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

variable "subnet_name" {
  description = "Specify the subnet name when 'vpc_id' is not specified."
  default     = "tf-modules-subnet"
}

variable "subnet_cidrs" {
  description = "Specify the subnet cidr blocks when 'vpc_id' is not specified."
  type        = list(string)
  default     = []
}

variable "subnet_is_multicast" {
  description = "Specify the subnet is multicast when 'vpc_id' is not specified."
  default     = true
}

variable "subnet_tags" {
  description = "Additional tags for the subnet."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "List of available zones to launch resources."
  type        = list(string)
  default     = []
}

variable "route_table_id" {
  description = "The route table id of router table in the specified vpc."
  default     = ""
}

variable "destination_cidrs" {
  description = "List of destination CIDR blocks of router table in the specified VPC."
  type        = list(string)
  default     = []
}

variable "next_type" {
  description = "List of next hop types of router table in the specified vpc."
  type        = list(string)
  default     = []
}

variable "next_hub" {
  description = "List of next hop gateway id of router table in the specified vpc."
  type        = list(string)
  default     = []
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}
