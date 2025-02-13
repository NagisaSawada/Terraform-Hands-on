# 以下S3バケットとIAM設定を管理するための変数定義
variable "bucket_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

# リソース名に付加する接尾辞
variable "resource_name_suffix" {
  type = string
}

