locals {
  cluster_id = "${var.name}-${var.env}" // @TODO make sure alarms work
}

resource "aws_security_group" "this" {
  provider    = aws.this
  name        = "allow-${var.name}-traffic"
  description = "Allow traffic on ${var.port} from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-redis-sg"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  provider   = aws.this
  name       = var.name
  subnet_ids = var.subnets
}

resource "aws_elasticache_replication_group" "this" {
  provider                    = aws.this

  replication_group_id        = "${var.name}-replication-group"
  description                 = "${var.name} cluster"

  engine                      = var.engine
  engine_version              = var.engine_version
  node_type                   = var.node_type
  port                        = 6379

  parameter_group_name        = var.parameter_group_name
  
  # High Availability Settings
  automatic_failover_enabled  = true
  multi_az_enabled            = true          
  num_node_groups             = var.shard_count   // Number of primary shards
  replicas_per_node_group     = var.replica_count // Number of replicas per shard
  preferred_cache_cluster_azs = ["us-east-1a", "us-east-1b"]
  
  # Networking
  subnet_group_name           = aws_elasticache_subnet_group.redis.id
  security_group_ids          = [aws_security_group.this.id]
  
  maintenance_window          = var.maintenance_window
  snapshot_name               = var.snapshot_name
  
  apply_immediately           = var.apply_immediately

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }
}

module "cpu_alarm" {
  source              = "../cloudwatch-metric"
  name                = "${var.name}-cpu-${var.env}"
  evaluation_periods  = 1
  period              = 300 # seconds
  threshold           = var.cpu_threshold
  statistic           = "Maximum"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/ElastiCache"
  topic               = var.sns_topic
  env                 = var.env
  treat_missing_data  = "missing"
  dimensions = {
    "CacheClusterId" = local.cluster_id // @TODO will this work ?
  }
  providers = {
    aws.this = aws.this
  }
}

module "bytes_used_for_cache_alarm" {
  source              = "../cloudwatch-metric"
  name                = "${var.name}-bytes-${var.env}"
  evaluation_periods  = 1
  period              = 300 # seconds
  threshold           = var.bytes_threshold
  statistic           = "Maximum"
  metric_name         = "BytesUsedForCache"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/ElastiCache"
  topic               = var.sns_topic
  env                 = var.env
  treat_missing_data  = "missing"
  dimensions = {
    "CacheClusterId" = local.cluster_id // @TODO will this work ?
  }
  providers = {
    aws.this = aws.this
  }
}