locals {
  public_subnet_args = {
    "ap-northeast-1a" = "10.0.0.0/24"
    "ap-northeast-1c" = "10.0.1.0/24"
  }

  private_subnet_args = {
    "ap-northeast-1a" = "10.0.2.0/24"
    "ap-northeast-1c" = "10.0.3.0/24"
  }

  resource_names = {
    vpc            = "tf-vpc"
    public_subnet  = "tf-public-subnet"
    private_subnet = "tf-private-subnet"
  }
}

# VPCの作成
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  # DNS解決を有効化
  enable_dns_support   = true
  # VPC内のEC2でホスト名を使えるようにする
  enable_dns_hostnames = true

  tags = {
    Name = local.resource_names.vpc
  }
}

# パブリックサブネットの作成
resource "aws_subnet" "public" {
  for_each = local.public_subnet_args

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${local.resource_names.public_subnet}-${each.key}"
  }
}

# プライベートサブネットの作成
resource "aws_subnet" "private" {
  for_each = local.private_subnet_args

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
    Name = "tf-internet-gateway"
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
    Name = "tf-public-route-table"
  }
}

# プライベートルートテーブルの作成
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id
  tags = {
    Name = "tf-private-route-table-${each.key}"
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
