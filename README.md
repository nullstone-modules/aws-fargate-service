# aws-fargate-service

Nullstone Block standing up an AWS Fargate container service using ECR and configured to emit to AWS CloudWatch Logs.

## Security & Compliance

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

[![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=INFRASTRUCTURE+SECURITY)
[![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/cis_aws_13)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=CIS+AWS+V1.3)
[![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=PCI-DSS+V3.2)
[![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=NIST-800-53)
[![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=ISO27001)
[![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=SOC2)
[![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=nullstone-modules%2Faws-fargate-service&benchmark=HIPAA)

## Inputs

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
- `service_port: number`
  - The port that the service is listening on.
    This is set to port 80 by default; however, if the service in the container is a non-root user,
    the service will fail due to bind due to permission errors.
    Specify 0 to disable network connectivity to this container.
  - Default: `80`
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
