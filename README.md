# Fargate Service

This app module is used to create a long-running service such as an API, Web App, or Background Worker.
To create a task/job that runs on a schedule or trigger, use Fargate Task.

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

This module uses [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html), which is a technology that allows you to run ECS container applications without managing EC2 boxes (Virtual Machines).

## App Support

- Environment Variables
- Secrets
- Network Access
- SSH Access
- Log Providers
- Load Balancers
- Sidecars
- Volumes
