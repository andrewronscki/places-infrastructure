resource "aws_lb_target_group" "this" {
  name        = "places-service-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path              = var.tg_health_check_path
    healthy_threshold = 2
  }
}

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = var.lb_arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }


# resource "aws_lb_listener_rule" "host_based_weighted_routing" {
#   listener_arn = ""
#   priority     = 99

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }

#   condition {
#     host_header {
#       values = ["${local.service_url}"]
#     }
#   }
# }

# data "aws_lb_listener" "http" {
#   arn = data.aws_lb.this.li

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = data.aws_lb.this.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }
