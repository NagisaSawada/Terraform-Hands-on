# 作成されたパブリックサブネットのIDをリストとして出力
output "public_subnet_ids" {
  value = [
    for subnet in aws_subnet.public : subnet.id
  ]
}

# 作成されたプライベートサブネットのIDをリストとして出力
output "private_subnet_ids" {
  value = [
    for subnet in aws_subnet.private : subnet.id
  ]
}

