# ── Identity ──────────────────────────────────────────────────────────────────

name = "my-redis"
env  = "test"

# ── Networking ────────────────────────────────────────────────────────────────
# Replace with real VPC/subnet IDs from your test AWS account

vpc_id  = "vpc-0abc123456789def0"
subnets = [
  "subnet-0aaa111111111aaaa", # us-east-1a
  "subnet-0bbb222222222bbbb", # us-east-1b
]

# ── Engine ────────────────────────────────────────────────────────────────────

engine               = "redis"
engine_version       = "7.2"
redis_port           = 6379
redis_node_type      = "cache.t3.micro" # cheap node for testing
parameter_group_name = "default.redis7.cluster.on"

# ── High Availability ─────────────────────────────────────────────────────────
# Minimal HA: 1 shard with 1 replica (still exercises Multi-AZ + auto-failover
# without the cost of a full prod cluster)

shard_count   = 1
replica_count = 1

# ── Operations ────────────────────────────────────────────────────────────────

maintenance_window       = "sun:05:00-sun:06:00"
apply_immediately        = true  # OK to apply immediately in test
snapshot_name            = null  # start fresh, no seed snapshot
snapshot_retention_limit = 1     # keep only 1 daily snapshot in test

# ── CloudWatch Alarms ─────────────────────────────────────────────────────────

sns_topic       = "arn:aws:sns:us-east-1:123456789012:test-alerts"
cpu_threshold   = 80               # %
bytes_threshold = 536870912        # 512 MB
