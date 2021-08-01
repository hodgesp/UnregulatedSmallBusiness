## Summary

This repo will create your custom environments. One which is a normal setup and another which is a bad one.


## Normal Architecture (Good)

![Design](.github/img/tf-patrick19791-good.png)

## Bad Architecture

![Design](.github/img/tf-patrick19791-bad.png)

## Built with:

* Terraform (v1.0.2)
* AWS_ACCESS_KEYS and AWS_SECRET_ACCESS_KEYS are set as environment variables (link: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

## Requirements:

* AWS Account
* AWS profile configured in your terminal

### Step by Step deployment
* **Step 1: Clone the Repo**. This command will clone the repo
```shell script
$ git clone https://github.com/antonio-rufo/tf-patrick19791.git
```

* **Step 2: Create your environment.** Update the `terraform.tfvars` file with your region. Then fill up all the optional variables (VPC details (cidr, subnet cidrs, etc.), EC2 details (size, desired_count, etc.), etc).
```shell script
$ cd tf-patrick19791/normal-setup
$ vi terraform.tfvars
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

* **Step 3: Create your bad environment.** Update the `terraform.tfvars` file with your region. Then fill up all the optional variables (EC2 details (size, desired_count, etc.), etc). Since we are using the default VPC, you dont need to update the any VPC detail anymore.
```shell script
$ cd ../bad-setup
$ vi terraform.tfvars
$ vi main.tf
```
Create the resources:
```shell script
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```
