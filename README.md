# Fargate Service

This app module is used to create a long-running service such as an API, Web App, or Background Worker.
To create a task/job that runs on a schedule or trigger, use Fargate Task.

## When to use

Fargate Service is a great choice for APIs, Web Apps, or Background Workers and you do not want to manage EC2 servers.

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-fargate-service/hipaa)

## Platform

This module uses [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html), which is a technology that allows you to run ECS container applications without managing EC2 servers (Virtual Machines).

## Network Access

When the service is provisioned, it is placed into private subnets on the connected network.
As a result, the Fargate Service can route to services on the private network *and* is accessible on the private network.

## Public Access

To enable public access to the service, add an `Ingress` capability.

In most cases, a `Load Balancer` capability is the best choice for exposing as it enables rollout deployments with no downtime.
Additionally, a `Load Balancer` allows you to split traffic between more than 1 task based on load.

## Logs

Logs are automatically emitted to AWS Cloudwatch Log Group: `/<task-name>`.
To access through the Nullstone CLI, use `nullstone logs` CLI command. (See [`logs`](https://docs.nullstone.io/getting-started/cli/docs.html#logs) for more information)

## Secrets

Nullstone automatically injects secrets into your Fargate Service through environment variables.
(They are stored in AWS Secrets Manager and injected by AWS during launch.)

## Metric Alarms

### Target Group

Load Balancers use Target Groups as a backend registration.
As more containers are launched, AWS automatically registers these containers with the Target Group.

This app module enables the creation of Cloudwatch metric alarms through capability outputs.
This is especially useful when creating auto-scaling capabilities based on metrics on the Target Group (e.g. `RequestCountPerTarget`).

To create a metric alarm in a capability, add an output that looks like the following.
Note that `type` must be `"target-group"` and `name` must be unique amongst metric alarms.
```hcl
output "metric_alarms" {
  value = [
    {
      type = "target-group"

      name                = "HighRequestCountPerTarget"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "2"
      metric_name         = "RequestCountPerTarget"
      namespace           = "AWS/ApplicationELB"
      period              = "60"
      statistic           = "Sum"
      threshold           = "1000"
      alarm_description   = "Triggers a scale up of containers when the TargetGroup has a high number of requests per target"
      actions             = jsonencode([aws_appautoscaling_policy.scale_up.arn])
    }
  ]
}

```
