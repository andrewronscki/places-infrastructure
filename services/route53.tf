resource "aws_route53_record" "this" {
  zone_id = lookup(var.ecs, local.env)["route53_zone_id"]
  name    = "api.places"
  type    = "CNAME"
  ttl     = "30"

  records = [aws_lb.this.dns_name]
}

// Criando DNS Para RDS
resource "aws_route53_record" "rds" {
  zone_id = lookup(var.ecs, local.env)["route53_zone_id"]
  name    = "database"
  type    = "CNAME"
  ttl     = "30"

  records = [aws_db_instance.this.address]
}
