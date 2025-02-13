# ALBのURLを出力
output "url" {
  value = "http://${module.alb.dns_name}"
}

