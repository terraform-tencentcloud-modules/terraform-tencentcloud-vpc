output "vpc_id" {
  description = "The id of vpc."
  value       = var.vpc_id != "" ? var.vpc_id : concat(tencentcloud_vpc.vpc.*.id, [""])[0]
}

output "subnet_id" {
  description = "The id of subnet."
  value       = tencentcloud_subnet.subnet.*.id
}

output "route_table_id" {
  description = "The id of route table."
  value       = tencentcloud_subnet.subnet.*.route_table_id
}

output "route_entry_id" {
  description = "The id of route table entry."
  value       = tencentcloud_route_table_entry.route_entry.*.id
}

output "availability_zones" {
  description = "The availability zones of instance type."
  value       = tencentcloud_subnet.subnet.*.availability_zone
}

output "acl_id" {
  description = "ID` of the network ACL instance."
  value       = tencentcloud_vpc_acl.default.*.id
}