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
  type    = string
  default = "terraform_keypair"
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "ssh_cidr_blocks" {
  type    = list(string)
  # 今回はデフォルトにマイIPを設定
  default = ["133.32.217.130/32"]
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

