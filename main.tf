data "aws_availability_zones" "all" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "${var.prefix} [${var.environment}]"
  }
}

resource "aws_subnet" "this" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]

  tags = {
    "Name" = "${var.prefix} [${var.environment}] az${count.index + 1}"
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    "Name" = "${var.prefix} [${var.environment}]"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "${var.prefix} [${var.environment}]"
  }
}

resource "aws_route" "wan" {
  route_table_id         = aws_default_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "subnets" {
  count = length(aws_subnet.this)

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_default_route_table.this.id
}
