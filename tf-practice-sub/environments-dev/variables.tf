# リソース名の接尾辞
variable "resource_name_suffix" {
  default = "dev"
}

# VPCのCIDRブロック
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# パブリックサブネットのCIDR
variable "public_subnet_args" {
  default = {
    "ap-northeast-1a" = "10.0.0.0/24"
    "ap-northeast-1c" = "10.0.1.0/24"
  }
}

# プライベートサブネットのCIDR 
variable "private_subnet_args" {
  default = {
    "ap-northeast-1a" = "10.0.2.0/24"
    "ap-northeast-1c" = "10.0.3.0/24"
  }
}

# EC2 に使用するキーペア名
variable "key_name" {
  default = "terraform_keypair"
}

# SSH接続を許可するCIDRブロックのリスト
variable "ssh_cidr_blocks" {
  default = ["133.32.217.130/32"]
}

# RDS名
variable "db_identifier" {
  default = "tf-database"
}

# RDSマスターユーザー名
variable "username" {
  default = "admin3"
}

# S3バケット名
variable "bucket_name" {
  default = "tf-s3-8913-7714-3345"
}

# IAMポリシー名
variable "policy_name" {
  default = "tf-s3-policy"
}

# IAMロール名
variable "role_name" {
  default = "tf-s3-access-role"
}

# IAMインスタンスプロファイル名
variable "instance_profile_name" {
  default = "tf-s3-access-instance-profile"
}

