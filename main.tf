terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "this"
  region = var.region
}

module "redis_cluster" {
  source = "./redis_cluster"

  # Identity
  name = var.name
  env  = var.env

  # Networking
  vpc_id  = var.vpc_id
  subnets = var.subnets

  # Engine
  engine               = var.engine
  engine_version       = var.engine_version
  port                 = var.redis_port
  node_type            = var.redis_node_type
  parameter_group_name = var.parameter_group_name

  # High Availability
  shard_count   = var.shard_count
  replica_count = var.replica_count

  # Operations
  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  apply_immediately        = var.apply_immediately
  snapshot_name            = var.snapshot_name
  snapshot_retention_limit = var.snapshot_retention_limit

  # CloudWatch Alarms
  sns_topic       = var.sns_topic
  cpu_threshold   = var.cpu_threshold
  bytes_threshold = var.bytes_threshold

  providers = {
    aws.this = aws.this
  }
}
