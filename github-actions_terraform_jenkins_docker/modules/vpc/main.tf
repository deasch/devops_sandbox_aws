data "aws_availability_zones" "available" {
	state = "available"
}

resource "aws_vpc" "aws_vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		Name = "aws_vpc"
	}
}

resource "aws_internet_gateway" "aws_igw" {
	vpc_id = aws_vpc.aws_vpc.id

	tags = {
		Name = "aws_igw"
	}
}

resource "aws_subnet" "aws_public_subnet" {
	vpc_id = aws_vpc.aws_vpc.id
	cidr_block = var.public_subnet_cidr_block
	availability_zone = data.aws_availability_zones.available.names[0]

	tags = {
		Name = "aws_public_subnet_1"
	}
}

resource "aws_route_table" "aws_public_rt" {
	vpc_id = aws_vpc.aws_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.aws_igw.id
	}
}

resource "aws_route_table_association" "public" {
	route_table_id = aws_route_table.aws_public_rt.id
	subnet_id = aws_subnet.aws_public_subnet.id
}
