# VPCのCIDRブロックの受け取り
variable "vpc_cidr" {
  type = string
}

# パブリックサブネットのCIDRのマップの受け取り
variable "public_subnet_args" {
  type = map(string)
}

# プライベートサブネットのCIDRのマップの受け取り
variable "private_subnet_args" {
  type = map(string)
}

# リソース名に付加する接尾辞
variable "resource_name_suffix" {
  type = string
}

