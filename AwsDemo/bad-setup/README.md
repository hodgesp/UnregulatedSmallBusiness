## Summary

Terraform code to create an insecure environment.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | (Required) Region where resources will be created. | string | `ap-southeast-2` | no |

##  Inputs for ASG

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ec2\_name | Name used across the resources created | `string` | n/a | yes |
| instance\_type | The type of the instance to launch | `string` | `""` | no |
| min\_size | The minimum size of the autoscaling group | `number` | `null` | no |
| max\_size | The maximum size of the autoscaling group | `number` | `null` | no |
| desired\_capacity | The number of Amazon EC2 instances that should be running in the autoscaling group | `number` | `null` | no |
| user\_data | The user data to provide when launching the instance. | `string` | `null` | no |

## Inputs for Elasticache

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| elasticache\_name | Name of Elasticache Redis Instance. | `string` | `n/a` | yes |

## Inputs for S3 bucket

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Prefix name of the S3 bucket | `string` | `n/a` | yes |

## Outputs

| Name | Description |
|------|-------------|
| all\_sg\_id | The ID of the ALL Security Group. |
| alb\_dns\_name | The DNS name of the load balancer. |
