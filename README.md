# block-aws-fargate-service

Nullstone Block standing up an AWS Fargate container service using ECR and configured to emit to AWS CloudWatch Logs.

## Inputs

- `owner_id: string` - Stack Owner ID
- `stack_name: string` - Stack Name
- `block_name: string` - Block Name (this represents the service name)
- `parent_blocks: object({ cluster: string })` - Parent Blocks (cluster = fargate cluster block name)
- `env: string` - Environment Name
- `backend_conn_str: string` - Connection string for postgres backend

- `enable_lb: bool`
  - Enable/Disable Load Balancer
  - Default: `true`
- `enable_https: bool`
  - Enable/Disable https listener on load balancer
  - Default: `false`
- `service_cpu: number`
  - Service CPU Allocation
  - Measure in CPU shares as defined by docker
  - Default: `256`
- `service_memory: number`
  - Service Hard-Limit on Memory
  - Measured in MB 
  - Default: `512`

## Outputs

- `log_group_name`
  - Name of CloudWatch Log Group for service
- `repo_name`
  - Container Image Name for Service
- `service_name`
  - Name of AWS ECS Service
- `task_family`
  - Name of single AWS ECS Task 
- `cluster_block`
  - Name of Cluster Block
- `network_block`
  - Name of Network Block
- `lb_arn`
  - Load Balancer ARN
- `lb_security_group_id`
  - Load Balancer Security Group
