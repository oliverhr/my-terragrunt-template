[![Maintained by @OliverHR](https://img.shields.io/twitter/follow/oliverhr?label=Maintained%20by%20OliverHR&style=social)](https://twitter.com/oliverhr)

# Project info

This code is to be used as the template for a single or multi-account terragrunt proyect.


## How do you deploy the infrastructure in this repo?


### Pre-requisites

1. [Terraform](https://www.terraform.io/downloads) version => `1.2.7`
1. [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) version => `v0.36.0`
1. [Pre-Commit](https://pre-commit.com/#install) version => `2.20.0`

### Setup

1. Set the proper value for your project name in `accounts/globals.hcl`
1. Update the root configuration file `accounts/terragrunt.hcl` if required.
1. Set the proper value for yours AWS Account ID's in `**/account.hcl`.
1. Set the proper value for yours AWS region `accounts/${account}/${region}/region.hcl`.
1. Set the proper value for yours environment values on `accounts/${account}/${region}/${env}/environment.hcl`.
1. Run `terragrunt run-all init` at `env` level.

This project use use **AWS S3** as [Terraform backend](https://www.terraform.io/docs/backends/types/s3.html) to store the Terraform state files, and **DynamoDB** for the state locking, when you run the `init` command you will be prompted to confirm the creation of these resources.

### Deploying a single module

1. Go into a module level `cd accounts/${account}/${region}/${env}/${module}`
1. Run `terragrunt plan` to see the changes in your infra.
1. Run `terragrunt apply` for the infra resources be created or modified.


### Deploying all modules in an environment

1. Go to the region folder `cd accounts/${account}/${region}/${env}`
1. Run `terragrunt plan-all` to see all the changes you're about to apply.
1. If the plan looks good, run `terragrunt apply-all`.


## How is the code in this repo organized?

The code in this repo uses the following folder hierarchy:

```
Accounts:
	└ account
 		└ region
 			└ environment
 				└ resource
```

Where:

* **Account**: At the top level are each AWS account, is recommended to use AWS Organizations for a multi-account approach.

* **Region**: Within each account, there will be one or more AWS regions where we deployed resources.

* **Environment**: Within each region, there will be one or more "environments", such as `qa`, `prod`, etc.

* **Resource**: We deploy/create all the AWS resources for each specific environment.

References:
- https://github.com/gruntwork-io/terragrunt-infrastructure-live-example
- https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example
