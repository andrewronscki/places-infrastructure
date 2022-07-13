// Criando a rede privada
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/21"
  tags       = merge(local.common_tags, { Name = "Place VPC" })
}

// Criando a internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "Place IG" })
}

// Criando as subnets
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${lookup(var.aws_region, local.env)}a"

  tags = merge(local.common_tags, { Name = "Place Public A" })
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${lookup(var.aws_region, local.env)}b"

  tags = merge(local.common_tags, { Name = "Place Public B" })
}

resource "aws_subnet" "pvt_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${lookup(var.aws_region, local.env)}a"

  tags = merge(local.common_tags, { Name = "Place Private A" })
}

resource "aws_subnet" "pvt_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${lookup(var.aws_region, local.env)}b"

  tags = merge(local.common_tags, { Name = "Place Private B" })
}

resource "aws_eip" "nat_gw_a" {
  vpc = true
}

resource "aws_eip" "nat_gw_b" {
  vpc = true
}

resource "aws_nat_gateway" "a" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat_gw_a.id

  tags = {
    Name = "NAT Gateway A"
  }
}

resource "aws_nat_gateway" "b" {
  subnet_id     = aws_subnet.public_b.id
  allocation_id = aws_eip.nat_gw_b.id

  tags = {
    Name = "NAT Gateway B"
  }
}

// Criando route table que aceitará conexão com a internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.common_tags, { Name = "Place Route Table Public" })
}

// Criando route table que não aceitará conexão da internet
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.a.id
  }

  tags = merge(local.common_tags, { Name = "Place Route Table Private A" })
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.b.id
  }

  tags = merge(local.common_tags, { Name = "Place Route Table Private B" })
}

// Associando as subnets para as route tables
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pvt_a" {
  subnet_id      = aws_subnet.pvt_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "pvt_b" {
  subnet_id      = aws_subnet.pvt_b.id
  route_table_id = aws_route_table.private_b.id
}
