// Create Places repository

resource "aws_ecr_repository" "this" {
  name = "places-service"

  tags = merge(local.common_tags, { Name = "Places Service Repository ECR" })
}

// Create Task Definition

data "template_file" "this" {
  template = file("../templates/services/ecs/myapp.json.tpl")

  vars = {
    app_image      = var.ecs_app_image
    app_port       = var.ecs_app_port
    host_port      = var.ecs_host_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    container_name = "places-service"
    service_name   = "places-service"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "places-service-td"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.this.rendered
}

// Create Service

resource "aws_ecs_service" "this" {
  name            = "places-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.ecs_app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.subnet_private_a_id, var.subnet_private_b_id]
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "places-service"
    container_port   = var.ecs_app_port
  }

  health_check_grace_period_seconds = 30

  tags = merge(local.common_tags, { Name = "Places ECS Service" })
}

# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
