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

# IAM: Secrets Manager Zugriff für ECS Task
resource "aws_iam_role_policy" "ecs_secrets" {
  name = "sonara-ecs-secrets"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue"]
      Resource = [
        aws_secretsmanager_secret.db_password.arn,
        "arn:aws:secretsmanager:eu-central-1:650825122607:secret:sonara/staging/firebase-service-account*"
      ]
    }]
  })
}

# Security Group für ALB (temporär auskommentiert — bei M1 Demo wieder einkommentieren)
# resource "aws_security_group" "alb" {
#   name   = "sonara-alb-sg"
#   vpc_id = aws_vpc.main.id
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# Application Load Balancer (temporär auskommentiert — ~18€/Monat)
# resource "aws_lb" "main" {
#   name               = "sonara-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb.id]
#   subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
#   tags               = { Name = "sonara-alb" }
# }

# Target Group (temporär auskommentiert)
# resource "aws_lb_target_group" "backend" {
#   name        = "sonara-backend-tg"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"
#   health_check {
#     path                = "/"
#     healthy_threshold   = 2
#     unhealthy_threshold = 3
#     interval            = 30
#   }
# }

# Listener (temporär auskommentiert)
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend.arn
#   }
# }

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/sonara-backend"
  retention_in_days = 7
}

# Task Definition
resource "aws_ecs_task_definition" "backend" {
  family                   = "sonara-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "backend"
    image = "${aws_ecr_repository.backend.repository_url}:latest"
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    environment = [
      { name = "NODE_ENV", value = "staging" },
      { name = "PORT",     value = "3000" },
      { name = "DB_HOST",  value = "sonara-staging.czwc4cwy61uu.eu-central-1.rds.amazonaws.com" },
      { name = "DB_PORT",  value = "5432" },
      { name = "DB_NAME",  value = "sonara" },
      { name = "DB_USER",  value = "sonara_admin" }
    ]
    secrets = [
      {
        name      = "DB_PASSWORD"
        valueFrom = aws_secretsmanager_secret.db_password.arn
      },
      {
        name      = "FIREBASE_SERVICE_ACCOUNT_JSON"
        valueFrom = "arn:aws:secretsmanager:eu-central-1:650825122607:secret:sonara/staging/firebase-service-account"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/sonara-backend"
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# Security Group für ECS Tasks
resource "aws_security_group" "ecs" {
  name   = "sonara-ecs-sg"
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Service (ohne ALB)
resource "aws_ecs_service" "backend" {
  name            = "backend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }
}