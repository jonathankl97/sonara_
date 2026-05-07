# Passwort in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "sonara/staging/db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

# Subnet-Gruppe für RDS
resource "aws_db_subnet_group" "main" {
  name       = "sonara-db-subnet"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# Security Group: nur aus dem VPC erreichbar
resource "aws_security_group" "rds" {
  name   = "sonara-rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "main" {
  identifier           = "sonara-staging"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "sonara"
  username             = "sonara_admin"
  password             = aws_secretsmanager_secret_version.db_password.secret_string
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  backup_retention_period = 0
  tags = { Name = "sonara-staging-db" }
}

# Redis Security Group
resource "aws_security_group" "redis" {
  name   = "sonara-redis-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Redis Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "sonara-redis-subnet"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# Redis
resource "aws_elasticache_cluster" "main" {
  cluster_id           = "sonara-staging"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis.id]
  tags = { Name = "sonara-staging-redis" }
}