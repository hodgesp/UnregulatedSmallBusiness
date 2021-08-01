## Summary

Terraform code to create your normal environment.

## Normal Architecture (Good)

![Design](../.github/img/tf-patrick19791-bad.png)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | (Required) Region where resources will be created. | string | `ap-southeast-2` | no |

## Inputs for VPC

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc\_name | VPC Name. | `string` | n/a | yes |
| vpc\_cidr | VPC CIDR block. | `string` | n/a | yes |
| map\_public\_ip\_on\_launch | Specify true to indicate that instances launched into the subnet should be assigned a public IP address. | `bool` | `false` | no |
| public\_cidr\_a | Public CIDR block A. | `string` | n/a | yes |
| public\_cidr\_b | Public CIDR block B. | `string` | n/a | yes |
| private\_cidr\_a | Private CIDR block A. | `string` | n/a | yes |
| private\_cidr\_b | Private CIDR block B. | `string` | n/a | yes |

## Inputs for Security Groups

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| source\_address | The address to allow to communicate with ALB. | `string` | `0.0.0.0/0` | no |

## Inputs for SSL

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain | The domain name to be put in the certificate registration. | `string` | `"example"` | no |

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
| vpc\_id | The ID of the VPC. |
| private\_subnets | List of IDs of private subnets. |
| public\_subnets | List of IDs of public subnets. |
| alb\_sg\_id | The ID of the ALB Security Group. |
| ec2\_sg\_id | The ID of the EC2 Security Group. |
| elasticache\_sg\_id | The ID of the Elasticache Security Group. |
| alb\_dns\_name | The DNS name of the load balancer. |
| ssl\_domain\_name | The domain name for which the certificate is issued. |
