resource "aws_ecs_cluster" "this" {
  name = "places"

  tags = merge(local.common_tags, { Name = "Cluster ECS Places" })
}
