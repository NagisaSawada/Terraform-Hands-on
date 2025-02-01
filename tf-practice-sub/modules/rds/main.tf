locals {
  resource_names = {
    rds_instance            = "tf-rds"
    rds_security_group_name = "tf-rds-sg"
    rds_subnet              = "tf-rds-subnet"
  }
}

# RDSサブネットグループの作成
resource "aws_db_subnet_group" "this" {
  name       = local.resource_names.rds_subnet
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = local.resource_names.rds_subnet
  }
}

# 既存のKMSキーを取得してRDSのストレージ暗号化に使用
data "aws_kms_alias" "rds" {
  name = "alias/aws/rds"
}

# RDS インスタンスの作成
resource "aws_db_instance" "this" {
  identifier        = var.db_identifier
  allocated_storage = var.allocated_storage
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.instance_class
  username          = var.username
  # AWS Secrets Managerにパスワードを自動管理させる設定
  manage_master_user_password = true
  # 第十回と同じ構成にするためシングルAZに設定
  multi_az                    = false
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.this.id]
  publicly_accessible         = false
  # RDSのストレージを暗号化
  storage_encrypted           = true
  # KMSキーを使用して暗号化
  kms_key_id                  = data.aws_kms_alias.rds.arn
  backup_retention_period     = var.backup_retention_period
  storage_type                = var.storage_type
  # 今回は練習のため容量を考慮しスナップショット不要に設定
  skip_final_snapshot = true 

  tags = {
    Name = local.resource_names.rds_instance
  }
}

# VPCサブネット情報の取得
data "aws_subnet" "this" {
  id = var.subnet_id
}

# RDSのセキュリティグループの作成
resource "aws_security_group" "this" {
  vpc_id = data.aws_subnet.this.vpc_id
  name   = local.resource_names.rds_security_group_name
  tags = {
    Name = local.resource_names.rds_security_group_name
  }
}

# EC2からRDSに接続できるようにポート3306を許可
resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  # 許可されたEC2からのみRDSにアクセス可能にする
  source_security_group_id = var.ec2_security_group_id
}

# 全トラフィックのアウトバウンドを許可する設定
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = ["0.0.0.0/0"]
}

