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
