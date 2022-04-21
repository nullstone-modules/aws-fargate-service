# 0.12.0 (Apr 21, 2022)

* Enabled in-transit encryption for EFS volumes.
* Using CMK (customer-managed key) when encrypting cloudwatch logs, secrets, and image repository.
* Enabled image scanning when an image is pushed to the image repository.
* Enabled tag immutability on the image repository. Can only push an image once.
