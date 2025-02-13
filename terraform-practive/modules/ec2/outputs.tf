# EC2インスタンスのIDを出力
output "instance_id" {
  value = aws_instance.this.id
}

# セキュリティグループのIDを出力
output "instance_security_group_id" {
  value = aws_security_group.this.id
}

