# S3バケットの作成
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

# S3のサーバーサイド暗号化を有効化
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      # AmazonS3標準の暗号化方式を使用
      sse_algorithm = "AES256"
    }
  }
}

# パブリックアクセスを完全にブロックする設定
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3に対するアクセス許可を定義したIAMポリシーを作成
resource "aws_iam_policy" "tf_s3_policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject", # オブジェクトの取得
          "s3:PutObject", # オブジェクトのアップロード
          "s3:ListBucket",# バケット内のファイル一覧取得
          "s3:DeleteObject", # オブジェクトの削除
          "s3:GetBucketLocation" # バケットのリージョン取得
        ]
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }
    ]
  })
}

# EC2で使用するIAMロールを作成
resource "aws_iam_role" "s3_access_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        # EC2にロールを割り当て可能にする設定
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = var.role_name
  }
}

# IAMロールにS3アクセスポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.tf_s3_policy.arn
}

# EC2にIAMロールを適用するためのインスタンスプロファイルを作成
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.s3_access_role.name
}

