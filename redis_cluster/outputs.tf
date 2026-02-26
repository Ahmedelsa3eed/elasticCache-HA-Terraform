output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.id
}

output "replication_group_arn" {
  description = "ARN of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.arn
}

# Use this when cluster mode is ENABLED (shard_count > 1).
# A cluster-aware Redis client (e.g. ioredis in cluster mode, redis-py-cluster) connects here
# and automatically routes commands to the correct shard for both reads and writes.
# primary_endpoint_address and reader_endpoint_address are NOT available in this mode.
output "configuration_endpoint_address" {
  description = "Cluster-mode entry point (available only when num_node_groups > 1). Use with a cluster-aware client for all reads and writes."
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

# Use this when cluster mode is DISABLED (shard_count = 1).
# Always points to the current primary node. Direct all WRITE operations here.
# If a failover occurs, AWS updates this endpoint automatically to the new primary.
output "primary_endpoint_address" {
  description = "Primary node endpoint (available only when num_node_groups = 1, i.e. cluster mode disabled). Use for writes."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

# Use this when cluster mode is DISABLED (shard_count = 1).
# Load-balances READ traffic across all replica nodes. Reduces load on the primary.
# Not available / not needed in cluster mode — the cluster handles read routing itself.
output "reader_endpoint_address" {
  description = "Reader endpoint (available only when cluster mode is disabled). Load-balances reads across all replicas."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "port" {
  description = "Port on which the cluster accepts connections"
  value       = aws_elasticache_replication_group.this.port
}

output "security_group_id" {
  description = "ID of the security group attached to the ElastiCache cluster"
  value       = aws_security_group.this.id
}

output "subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.redis.name
}
