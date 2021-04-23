# block-aws-fargate-service

Nullstone Block standing up an AWS Fargate container service using ECR and configured to emit to AWS CloudWatch Logs.

## Inputs

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
- `service_image: string`
  - The docker image to deploy for this service.
  - The version from the nullstone application will be used as the image tag.
  - Default: `""` - An ECR repo will be created and used.
- `service_env_vars: map(string)`
  - Map of environment variables to inject into the service

## Outputs

- `cluster_arn: string`
  - Fargate Cluster ARN
- `log_group_name: string`
  - Name of CloudWatch Log Group for service
- `image_repo_name: string`
  - Container Image Name for service
- `image_repo_url: string`
  - Container Image Repo URL for service
- `image_pusher: object({name: string, access_key: string, secret_key: string)`
  - An AWS user that has explicit permission to push to created ECR repo
- `service_image: string`
  - Full image URL for the service's docker image
- `service_name: string`
  - Name of AWS ECS Service
- `service_id: string`
  - AWS ECS Service ID
- `task_family: string`
  - Name of single AWS ECS Task
- `service_security_group_id: string`
  - Security Group ID for the service
- `target_group_arn: string`
  - Load Balancer Target Group ARN
- `lb_arn: string`
  - Load Balancer ARN
- `lb_security_group_id: string`
  - Load Balancer Security Group
