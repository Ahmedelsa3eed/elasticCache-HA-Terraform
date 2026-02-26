variable "name" {
  description = "Name prefix for all resources in this module"
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
  description = "List of subnet IDs for the ElastiCache subnet group"
  type        = list(string)
}

variable "port" {
  description = "Port on which Redis accepts connections"
  type        = number
  default     = 6379
}

variable "engine_version" {
  description = "Redis engine version (e.g. 7.1)"
  type        = string
  default     = "7.2"
}

variable "node_type" {
  description = "ElastiCache node type (e.g. cache.r7g.large)"
  type        = string
}

variable "parameter_group_name" {
  description = "Name of the ElastiCache parameter group to associate"
  type        = string
  default     = "default.redis7.cluster.on"
}

variable "shard_count" {
  description = "Number of primary shards (node groups) in the cluster"
  type        = number
  default     = 1
}

variable "replica_count" {
  description = "Number of read replicas per shard. Must be >= 1 when multi_az_enabled is true"
  type        = number
  default     = 1
}

variable "maintenance_window" {
  description = "Weekly time range for maintenance (e.g. sun:05:00-sun:06:00)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "apply_immediately" {
  description = "Whether changes should be applied immediately or during next maintenance window"
  type        = bool
  default     = false
}

variable "snapshot_name" {
  description = "Name of a snapshot to restore from when creating the cluster. Leave null to start fresh"
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Number of snapshots to retain for the ElastiCache cluster"
  type        = number
  default     = 7
}

# ── CloudWatch Alarms ────────────────────────────────────────────────────────

variable "sns_topic" {
  description = "ARN of the SNS topic to send alarm notifications to"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization percentage that triggers the CPUUtilization alarm"
  type        = number
  default     = 75
}

variable "bytes_threshold" {
  description = "Bytes used for cache that triggers the BytesUsedForCache alarm"
  type        = number
}
