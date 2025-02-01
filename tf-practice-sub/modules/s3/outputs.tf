# S3バケット名の出力
output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}

# S3バケットのARNを出力
output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
}

# EC2に付与されるIAMロールのARNを出力
output "s3_access_role_arn" {
  value = aws_iam_role.s3_access_role.arn
}

# EC2にアタッチするIAMインスタンスプロファイル名を出力
output "s3_access_instance_profile_name" {
  value = aws_iam_instance_profile.s3_access_profile.name
}

