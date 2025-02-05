locals {
  resource_names = {
    vpc            = "tf-vpc-${var.resource_name_suffix}"
    public_subnet  = "tf-public-subnet-${var.resource_name_suffix}"
    private_subnet = "tf-private-subnet-${var.resource_name_suffix}"
  }
}

# VPCの作成
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  # DNS解決を有効化
  enable_dns_support = true
  # VPC内のEC2でホスト名を使えるようにする
  enable_dns_hostnames = true

  tags = {
    Name = local.resource_names.vpc
  }
}

# パブリックサブネットの作成
resource "aws_subnet" "public" {
  for_each = var.public_subnet_args

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${local.resource_names.public_subnet}-${each.key}"
  }
}

# プライベートサブネットの作成
resource "aws_subnet" "private" {
  for_each = var.private_subnet_args

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${local.resource_names.private_subnet}-${each.key}"
  }
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "tf-internet-gateway-${var.resource_name_suffix}"
  }
}

# パブリックルートテーブルの作成
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "tf-public-route-table-${var.resource_name_suffix}"
  }
}

# プライベートルートテーブルの作成
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id
  tags = {
    Name = "tf-private-route-table-${var.resource_name_suffix}-${each.key}"
  }
}

# パブリックルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# プライベートルートテーブルの関連付け
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

