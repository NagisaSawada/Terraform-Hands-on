locals {
  resource_names = {
    security_group = "tf-alb-sg"
  }
}

# ALBの作成
resource "aws_lb" "this" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids
}

# ALBのリスナー（HTTP:80）の作成
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  
  # すべてのリクエストをターゲットグループへ転送
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# ターゲットグループの作成
resource "aws_lb_target_group" "this" {
  # 受け取ったリクエストをEC2のポート80に転送
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.this.vpc_id
}

# EC2をターゲットグループに追加
resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_id
}

# VPCのサブネットIDのリストから最初のサブネットID を取得
data "aws_subnet" "this" {
  id = var.subnet_ids[0]
}

# ALB用のセキュリティグループを作成
resource "aws_security_group" "this" {
  vpc_id = data.aws_subnet.this.vpc_id
  name   = local.resource_names.security_group
  tags = {
    Name = local.resource_names.security_group
  }
}

# ALBのHTTPトラフィックを許可
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

# ALBからのすべてのアウトバウンド通信を許可
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

# ALBからEC2へのHTTP通信を許可
resource "aws_security_group_rule" "alb_to_instance" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
  security_group_id        = var.instance_security_group_id
}

