# 以下S3バケットとIAM設定を管理するための変数定義
variable "bucket_name" {
  type    = string
  default = "tf-s3-8913-7714-3345"
}

variable "policy_name" {
  type    = string
  default = "tf-s3-policy"
}

variable "role_name" {
  type    = string
  default = "tf-s3-access-role"
}

variable "instance_profile_name" {
  type    = string
  default = "tf-s3-access-instance-profile"
}

