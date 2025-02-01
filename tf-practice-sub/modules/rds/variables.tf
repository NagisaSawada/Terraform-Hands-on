# 以下RDSインスタンスの作成に必要なパラメータを管理するための変数定義
variable "subnet_id" {
  type = string
}


variable "db_identifier" {
  type    = string
  default = "tf-database"
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
  default = "8.0.35"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "username" {
  type    = string
  default = "admin3"
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

