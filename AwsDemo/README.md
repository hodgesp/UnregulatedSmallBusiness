## Summary

This repo will create your environment in AWS.


## Built with:

* Terraform (v1.0.2)
* AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Requirements:

* AWS Account
* AWS profile configured in your terminal

### Step by Step deployment
* **Step 1: Clone the Repo**. This command will clone the repo

* **Step 2: Create your environment.** Update the `terraform.tfvars` file with your region. Then fill up all the optional variables (VPC details (cidr, subnet cidrs, etc.), EC2 details (size, desired_count, etc.), etc).


* **Step 3: Create the resources:**
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
