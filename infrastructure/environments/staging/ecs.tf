# ECR Repository für das Backend
resource "aws_ecr_repository" "backend" {
  name                 = "sonara/backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = { Name = "sonara-backend" }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "sonara-staging"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# IAM Rolle für ECS Tasks
resource "aws_iam_role" "ecs_task_execution" {
  name = "sonara-ecs-task-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "sonara-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}