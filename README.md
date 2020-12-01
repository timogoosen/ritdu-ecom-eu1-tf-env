# tf-common

Terraform Common, every terraform based app will have to include this repo.

## Requirements

1. AWS cli with profile `rimu` set up correctly.
2. Terraform

## Infrastructure

**Rationale:**

* Squeeze as much as possible out of the private IP range
* RIMU has rather a high number of projects than a project with high number of hosts
* Caveat: difficult to do simple math predictions, but should be easy with any cidr calc
* See: http://cidr.xyz/

### VPC CIDR

* any core/base environment: `172.16.0.0 - 172.31.255.255`
* any office IP (VPN): `192.168.0.0 - 192.168.255.255`
* any project: `10.0.0.0 - 10.255.255.255`

---

|**core/base**      |     base      |      qa        |    staging     |     prod        |     base-sg     |
|------------------ | ------------- | ------------   | -------------- | --------------- |---------------- |
|rimu               | 172.16.0.0/19 | 172.32.0.0/19  |                | 172.16.96.0/19  | 172.16.128.0/19 |

|**projects**       |     base      |      qa        |    staging     |     prod        |     base-sg     |
|------------------ | ------------- | ------------   | -------------- | --------------- |---------------- |
|ritdu-jobs-af1      | 10.12.0.0/19  | 10.12.32.0/19  | 10.12.64.0/19  | 10.12.96.0/19   |                 |
|ritdu-cars-af1      | 10.13.0.0/19  | 10.13.32.0/19  | 10.13.64.0/19  | 10.13.96.0/19   |                 |
|roam-horizon-af1   | 10.14.0.0/19  | 10.14.32.0/19  | 10.14.64.0/19  | 10.14.96.0/19   |                 |
|ritdu-dcd          | 10.15.0.0/19  | 10.15.32.0/19  | 10.15.64.0/19  | 10.15.96.0/19   |                 |
|rimu-prop-vnm      | 10.16.0.0/19  | 10.16.32.0/19  | 10.16.64.0/19  | 10.16.96.0/19   |                 |
|ritdu-pe-eu1        | 10.17.0.0/19  | 10.17.32.0/19  | 10.17.64.0/19  | 10.17.96.0/19   |                 |
|ritdu-dcd-eu2      | 10.18.0.0/19  | 10.18.32.0/19  | 10.18.64.0/19  | 10.18.96.0/19   |                 |
|cube-sdc-eu1       | 10.19.0.0/19  | 10.19.32.0/19  | 10.19.64.0/19  | 10.19.96.0/19   |                 |
|ritdu-qme-eu1       | 10.20.0.0/19  | 10.20.32.0/19  | 10.20.64.0/19  | 10.20.96.0/19   |                 |
|ritdu-hex-eu1      | 10.21.0.0/19  | 10.21.32.0/19  | 10.21.64.0/19  | 10.21.96.0/19   |                 |
|ritdu-cars-af1      | 10.22.0.0/19  | 10.22.32.0/19  | 10.22.64.0/19  | 10.22.96.0/19   |                 |
|ritdu-meta-eu1     | 10.23.0.0/19  | 10.23.32.0/19  | 10.23.64.0/19  | 10.23.96.0/19   |                 |
|ritdu-bi-eu1     | 10.24.0.0/19  | 10.24.32.0/19  | 10.24.64.0/19  | 10.24.96.0/19   |                 |
|ritdu-mkt-eu1     | 10.25.0.0/19  | 10.25.32.0/19  | 10.25.64.0/19  | 10.25.96.0/19   |                 |
|ritdu-ecom-eu1     | 10.26.0.0/19  | 10.26.32.0/19  | 10.26.64.0/19  | 10.26.96.0/19   |                 |


---

|**office**         |     range       |
|------------------ | -------------   |
|users              | 10.0.0.0/24     |
|vpn                | 192.168.2.0/24  |

*office users pending migrate to 192.168.1.0/24

### VPC Subnets

* Every project has its own `/16` - divided into `/19` per environment, meaning every environment can have up to `8192` hosts.
* Every availability zone has its own `/24`.
* Every subnet-group can over span maximum of 5 availability zones.
* Every environment can have max 6 subnet groups.
* Every project can have max 8 environments.

# Day One Operations

## Bootstrapping new projects

Clone this project into a infra sub-folder:

```
cd your-app-name

git clone git@github.com:RingierIMU/tf-common.git infra


```
Make sure to remove the .git directory in the infra folder, otherwise git will think this is a seperate project inside your project:

```
rm -rf infra/.git

```



Initialise the environments (will create blank Terraform state files in S3)

* `APP_NAME` should be the name of your git repository
* `PREFIX` should be the name of the project (rimu, rimu-prop-vnm, etc.)
* `PREFIX_SHORT` same as above but without "rimu" (used mainly for sub-domains)

```
APP_NAME=your-app-name PREFIX=rimu PREFIX_SHORT= infra/tf.sh create qa staging prod

```
Here is an example:

```
APP_NAME="ritdu-pe-eu1-tf-env" PREFIX="ritdu-pe-eu1" PREFIX_SHORT="pe-eu1" ./tf.sh create prod qa staging

```


## Terraform only projects

Move the contents within the /infra sub-folder to your new project's root dir

## Normal projects

Leave the contents of /infra in the sub-folder as is

## Plan & apply

It is perfectly fine to run `terraform plan` and `terraform apply` from your workstation, as it will connect to S3 + DynamoDB to keep states.
Obviously this is discouraged and should only be done in the event of an emergency.

# Day Two Operations

## Upgrading projects

```bash
infra/tf.sh upgrade
```

# Misc

## From scratch without remote state

These instructions are only relevant when bootstrapping Terraform without any remote state yet configured.

* disable `_backend.tf` for now
* init `$ terraform init`
* create base workspace `$ terraform workspace new base`
* plan & apply
* first tf-env, then tf-base
