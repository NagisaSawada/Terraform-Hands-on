# RDSの接続エンドポイントを出力
output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}

# RDSインスタンスのARNを出力
output "db_instance_arn" {
  value = aws_db_instance.this.arn
}

