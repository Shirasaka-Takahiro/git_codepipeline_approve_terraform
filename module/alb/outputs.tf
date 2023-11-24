output "alb_name" {
  value = aws_lb.alb.name
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}

output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_https_listener_arn" { 
  value = aws_lb_listener.alb_https_listener.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "tg_blue_arn" {
  value = aws_lb_target_group.blue.arn
}

output "tg_green_arn" {
  value = aws_lb_target_group.blue.arn
}

output "tg_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "tg_green_name" {
  value = aws_lb_target_group.green.name
}

output "tg_blue_arn_suffix" {
  value = aws_lb_target_group.blue.arn_suffix
}

output "tg_green_arn_suffix" {
  value = aws_lb_target_group.green.arn_suffix
}