output "id" {
  value = aws_vpc.this.id
}

output "subnets" {
  value = aws_subnet.this.*.id
}

output "security_group" {
  value = aws_vpc.this.default_security_group_id
}

output "availability_zones" {
  value = data.aws_availability_zones.all.names
}
