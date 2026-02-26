# ──────────────────────────────────────────────────────────────────────────────
# Terraform module for deploying a highly available Redis cluster on AWS ElastiCache
variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g. prod, staging, dev)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ElastiCache cluster will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ElastiCache subnet group (spread across AZs)"
  type        = list(string)
}

variable "engine" {
  description = "Cache engine to use (redis or valkey)"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.2"
}

variable "redis_port" {
  description = "Port on which Redis accepts connections"
  type        = number
  default     = 6379
}

variable "redis_node_type" {
  description = "ElastiCache node instance type (e.g. cache.r7g.large)"
  type        = string
}

variable "parameter_group_name" {
  description = "Name of the ElastiCache parameter group"
  type        = string
  default     = "default.redis7.cluster.on"
}

variable "shard_count" {
  description = "Number of primary shards. >1 enables cluster mode. Must match preferred_cache_cluster_azs count or be a multiple of it"
  type        = number
  default     = 2
}

variable "replica_count" {
  description = "Number of read replicas per shard. Must be >= 1 for Multi-AZ"
  type        = number
  default     = 2
}

# ── Operations ────────────────────────────────────────────────────────────────

variable "maintenance_window" {
  description = "Weekly UTC maintenance window (e.g. sun:05:00-sun:06:00)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "apply_immediately" {
  description = "Apply changes immediately rather than at next maintenance window. Set false for prod"
  type        = bool
  default     = true
}

variable "snapshot_name" {
  description = "Name of an existing snapshot to seed the cluster from. Null starts fresh"
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Number of daily snapshots to retain (0 disables automated snapshots)"
  type        = number
  default     = 7
}

# ── CloudWatch Alarms ─────────────────────────────────────────────────────────

variable "sns_topic" {
  description = "ARN of the SNS topic for alarm notifications"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization (%) that triggers the alarm"
  type        = number
  default     = 75
}

variable "bytes_threshold" {
  description = "BytesUsedForCache value (bytes) that triggers the alarm"
  type        = number
}
