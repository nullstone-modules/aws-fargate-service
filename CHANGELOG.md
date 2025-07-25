# 0.13.43 (Jul 21, 2025)
* Revert service discovery deprecation as it causes Terraform to fail.

# 0.13.42 (Jul 21, 2025)
* Allow more than one EFS volume attached to fargate service.
* Fixed deprecation warnings in new AWS terraform provider.

# 0.13.41 (Jul 21, 2025)
* Upgraded all terraform providers to latest.

# 0.13.40 (Jul 09, 2025)
* Added `nullstone.io/version` tag to task definition.

# 0.13.39 (Apr 30, 2025)
* Configured main container with `pseudoTerminal`.

# 0.13.38 (Apr 04, 2025)
* Added support for mounting `volumes` to the fargate task defined in capabilities. 

# 0.13.37 (Jan 22, 2025)
* When an app secret is removed, it is immediately deleted from AWS secrets manager.

# 0.13.36 (Nov 18, 2024)
* Propagate tags from ECS service to ECS tasks.

# 0.13.35 (Nov 05, 2024)
* Fixed failed Terraform plans when creating secrets on initial launch.

# 0.13.34 (Oct 26, 2024)
* Fixed inconsistency with env vars/secrets interpolation.

# 0.13.33 (Sep 16, 2024)
* Fixed removal of `ulimit` capability.

# 0.13.32 (Sep 16, 2024)
* Fixed `ulimit` capabilities definition.

# 0.13.31 (Sep 16, 2024)
* Added `app/` prefix to cpu and memory metrics so they are grouped on the dashboard.
* Added support for `ulimit` on main container definition from capability modules.

# 0.13.30 (May 17, 2024)
* Fixed issue with `.terraform.lock.hcl` containing `tlkamp/validation`.

# 0.13.29 (May 16, 2024)
* Upgraded Terraform providers.

# 0.13.28 (Mar 19, 2024)
* Removed extra `validation` stanza from `.terraform.lock.hcl` that prevented plans from running.

# 0.13.27 (Mar 19, 2024)
* Upgrade terraform providers (aws -> `5.41.0`).

# 0.13.26 (Feb 10, 2024)
* Added permissions to list image tags in image repository.

# 0.13.25 (Feb 06, 2024)
* Added support for metrics for capabilities.

# 0.13.24 (Jan 15, 2024)
* Fixed mapping syntax.

# 0.13.23 (Jan 15, 2024)
* Added metrics configuration. (`metrics_provider`, `metrics_reader`, `metrics_mappings`)

# 0.13.22 (Dec 28, 2023)
* Added support for querying metric data from the log reader.

# 0.13.21 (Dec 28, 2023)
* Added support for "target-group" metric alarms.

# 0.13.20 (Nov 09, 2023)
* Added `execution_role_name` to injected `app_metadata` in capabilities.
* Increased default `var.health_check_grace_period` to `30s`.

# 0.13.19 (Oct 30, 2023)
* Fixed `var.health_check_grace_period` to configure only when load balancers are attached. 

# 0.13.18 (Oct 30, 2023)
* Added `var.health_check_grace_period` to delay enforcement of failed health checks.

# 0.13.12 (Sep 27, 2023)
* Added support for `secret()` ref.

# 0.13.11 (Aug 08, 2023)
* Updated `README.md` with application management info.

# 0.13.10 (Jul 25, 2023)
* Prevent collisions of fargate services when using shared infrastructure.

# 0.13.8 (Jun 23, 2023)
* Added optional `var.command` to override image `CMD`.

# 0.13.7 (Jun 21, 2023)
* Fixed "known after apply" for event capabilities.

# 0.13.6 (Jun 21, 2023)
* Added support for events.
* Changed `task_definition_arn` to `task_definition_name` to avoid cyclical dependencies.

# 0.13.4 (Jun 20, 2023)
* Added `task_definition_name` and `launch_type` to `app_metadata` for capabilities.

# 0.13.3 (Jun 14, 2023)
* Fixed duplicate port mappings when using sidecars.

# 0.13.2 (May 30, 2023)
* Added support for additional ports in load balancers.

# 0.13.1 (May 23, 2023)
* Changed service discovery to gracefully update a namespace changes using `create_before_destroy`.

# 0.13.0 (Apr 25, 2023)
* Changed `cluster` connection to `cluster-namespace` connection.
* Dropped `service_` prefix from variables.

# 0.12.21 (Feb 24, 2023)
* Fixed capability generation to emit variable that is set to a zero value, but not nil.

# 0.12.20 (Feb 16, 2023)
* Fixed `.terraform.lock.hcl`.

# 0.12.19 (Feb 16, 2023)
* Fixed "(known after apply)" issue with secret interpolation.

# 0.12.18 (Feb 15, 2023)
* Added variable `ephemeral_storage` to allow a user to expand the disk.
* Added `.terraform.lock.hcl` to module.

# 0.12.17 (Feb 14, 2023)
* Added env var interpolation to all environment variables (including secrets) injected into the app.

# 0.12.16 (Feb 09, 2023)
* Fixed incorrect usage of `signum` in security group updates.

# 0.12.15 (Feb 09, 2023)
* Fix security groups from failing when network does not have private or public subnets.

# 0.12.14 (Feb 01, 2023)
* Fixed generation of newlines in capabilities template.

# 0.12.13 (Jan 24, 2023)
* Updated capabilities template to not generate a capability variable if the value is `null`.

# 0.12.12 (Oct 24, 2022)
* Added `NULLSTONE_STACK`, `NULLSTONE_APP`, `NULLSTONE_VERSION`, `NULLSTONE_COMMIT_SHA` to app env vars.

# 0.12.11 (Oct 11, 2022)
* Add support for overriding the run command of a sidecar container.

# 0.12.10 (Oct 05, 2022)
* Fix reading of secrets keys.

# 0.12.9 (Sep 29, 2022)
* Fix "known after apply" error.

# 0.12.8 (Sep 29, 2022)
* Added support capability namespace.
* Added `service_secrets` variable to enable user-created secrets that are marked sensitive.

# 0.12.7 (Jul 26, 2022)
* Configured `aws_ecr_repository` with `force_delete` to fix destroy plans.

# 0.12.6 (Jul 01, 2022)
* Removed outputs: `service_image`, `service_id`, `task_family`.
* Added outputs: `task_arn`.
* Renamed output: `service_security_group_id` => `app_security_group_id`.

# 0.12.5 (Jun 11, 2022)
* Upgrade `ns_connection` to use `contract` instead of `type`.

# 0.12.4 (Jun 07, 2022)
* Fixed `random_string` to use `numeric` instead of deprecated `number`.
* Added description to `region` output.

# 0.12.3 (May 23, 2022)
* Created unique secret names that don't collide with deletes.

# 0.12.2 (May 13, 2022)
* Added `NULLSTONE_PUBLIC_HOSTS` and `NULLSTONE_PRIVATE_HOSTS` to app env vars.
* Added `public_hosts` and `private_hosts` outputs.
* Fixed ECR repository being replaced on every apply due to using KMS alias instead of KMS key.

# 0.12.1 (May 03, 2022)
* Fixed access to app secrets encryption key.

# 0.12.0 (Apr 21, 2022)
* Enabled in-transit encryption for EFS volumes.
* Using CMK (customer-managed key) when encrypting cloudwatch logs, secrets, and image repository.
* Enabled image scanning when an image is pushed to the image repository.
* Enabled tag immutability on the image repository. Can only push an image once.
