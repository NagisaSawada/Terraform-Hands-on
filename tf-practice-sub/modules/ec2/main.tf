locals {
  resource_names = {
    ec2_instance   = "tf-ec2"
    security_group = "tf-ec2-sg"
  }
}

# EC2インスタンスの作成
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  # true の場合パブリックIPを割り当てる設定
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  # IAMロールを設定
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = local.resource_names.ec2_instance
  }
}

# サブネット情報の取得
data "aws_subnet" "this" {
  id = var.subnet_id
}

# セキュリティグループの作成
resource "aws_security_group" "this" {
  # サブネットが属するVPCのIDを取得
  vpc_id = data.aws_subnet.this.vpc_id
  name   = local.resource_names.security_group
  tags = {
    Name = local.resource_names.security_group
  }
}

# SSH許可ルールの設定
resource "aws_security_group_rule" "ssh" {
  # var.allow_sshがtrueの場合SSHルールを作成
  count = var.allow_ssh ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_cidr_blocks
  security_group_id = aws_security_group.this.id
}

/*ALBからのアクセスを許可する設定にしたためコメントアウト
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
*/

# 全トラフィックのアウトバウンドを許可する設定
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

