variable "name" {
  type = string
  default = ""
}
variable "vpc_id" {
  type = string
  default = ""
}
variable "bandwidth" {
  default = 100
}
variable "max_concurrent" {
  default = 1000000
}

variable "tags" {
  type = map(string)
  default = {}
}

variable eips {
  type = list(object({
    internet_charge_type = optional(string)
    internet_max_bandwidth_out = optional(number)
    internet_service_provider = optional(string)
  }))
  default = []
}