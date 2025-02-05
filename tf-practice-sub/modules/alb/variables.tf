# 複数のサブネットIDをリストで受け取り、ALBを配置するサブネットを指定する際に利用
variable "subnet_ids" {
  type = list(string)
}

# ALBがトラフィックをルーティングするEC2のIDを指定しターゲットグループにEC2を登録するために利用
variable "instance_id" {
  type = string
}

# ALBからEC2への通信を許可するため、EC2のセキュリティグループIDを取得
variable "instance_security_group_id" {
  type = string
}

# リソース名に付加する接尾辞
variable "resource_name_suffix" {
  type = string
}

