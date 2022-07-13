terraform {
  required_version = ">1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }

  backend "s3" {
    bucket         = "places-terraform-state"
    key            = "services/terraform.tfstate"
    dynamodb_table = "places-terraform-state"
    region         = "us-east-1"
    profile        = "default"
  }
}

provider "aws" {
  region  = lookup(var.aws_region, local.env)
  profile = var.aws_profile
}

module "places-service" {
  source               = "./places-service"
  env                  = local.env
  aws_region           = lookup(var.aws_region, local.env)
  certificate_arn      = lookup(var.ecs, local.env)["certificate_arn"]
  route53_zone_id      = lookup(var.ecs, local.env)["route53_zone_id"]
  lb_arn               = aws_lb.this.arn
  lb_security_group_id = aws_security_group.alb.id
  vpc_id               = aws_vpc.this.id
  subnet_public_a_id   = aws_subnet.public_a.id
  subnet_public_b_id   = aws_subnet.public_b.id
  subnet_private_a_id  = aws_subnet.pvt_a.id
  subnet_private_b_id  = aws_subnet.pvt_b.id
  cluster_id           = aws_ecs_cluster.this.id
}
