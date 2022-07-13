resource "aws_db_instance" "this" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}
