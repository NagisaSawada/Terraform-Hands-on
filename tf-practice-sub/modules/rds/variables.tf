# 以下RDSインスタンスの作成に必要なパラメータを管理するための変数定義
variable "subnet_id" {
  type = string
}


variable "db_identifier" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  # Cfn構築時のv-8.0.35は標準サポート終了日が近いため変更
  default = "8.0.40" 
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "username" {
  type = string
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "ec2_security_group_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

# リソース名に付加する接尾辞
variable "resource_name_suffix" {
  type = string
}

