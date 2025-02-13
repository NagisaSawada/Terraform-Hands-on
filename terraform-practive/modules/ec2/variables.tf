# 以下EC2インスタンスの作成に必要なパラメータを管理するための変数定義
variable "ami" {
  type    = string
  default = "ami-075cc63e37ba74823"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "ssh_cidr_blocks" {
  type = list(string)
}

variable "allow_ssh" {
  type    = bool
  default = true
}

variable "subnet_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

# リソース名に付加する接尾辞
variable "resource_name_suffix" {
  type = string
}

