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
  value       = local.route_table_id
}

output "route_entry_id" {
  description = "The id of route table entry."
  value       = tencentcloud_route_table_entry.route_entry.*.id
}

output "availability_zones" {
  description = "The availability zones of instance type."
  value       = tencentcloud_subnet.subnet.*.availability_zone
}

output "tags" {
  description = "A map of tags to add to all resources."
  value       = var.tags
}

output "vpn_gateway_id" {
  description = "The ID of the VPN Gateway"
  value       = try(tencentcloud_vpn_gateway.vpn[0].id, "")
}

output "vpn_gateway_public_ip_address" {
  description = "The public ip address of the VPN Gateway"
  value       = try(tencentcloud_vpn_gateway.vpn[0].public_ip_address, "")
}

output "network_acl_id" {
  description = "The ID of the network ACL of the Default VPC"
  value       = try(tencentcloud_vpc_acl.acl[0].id, "")
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = try(tencentcloud_nat_gateway.nat[0].id, "")
}