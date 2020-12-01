# 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 #
# 💥                                                                        💥 #
# 💥 Do not edit this file as it will be overwritten!                       💥 #
# 💥                                                                        💥 #
# 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 💥 #



ns_env_name = "staging"

vpcs = {
  # we unfortunately can not mix types, but will be fixed in 0.12 (see: https://github.com/hashicorp/terraform/issues/14322)
  "ritdu-dcd-eu2.cidr"             = "10.18.64.0/19"
  "ritdu-dcd-eu2.single_natgw"     = "true"
  "ritdu-dcd-eu2.private_subs"     = "10.18.64.0/24 10.18.65.0/24 10.18.66.0/24"
  "ritdu-dcd-eu2.database_subs"    = "10.18.69.0/24 10.18.70.0/24 10.18.71.0/24"
  "ritdu-dcd-eu2.elasticache_subs" = "10.18.74.0/24 10.18.75.0/24 10.18.76.0/24"
  "ritdu-dcd-eu2.public_subs"      = "10.18.79.0/24 10.18.80.0/24 10.18.81.0/24"
  "ritdu-dcd-eu2.region"           = "eu-west-1"
  "ritdu-dcd-eu2.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-dcd-eu2.account_id"       = "520152236921"

  "ritdu-pe-eu1.cidr"             = "10.17.64.0/19"
  "ritdu-pe-eu1.single_natgw"     = "true"
  "ritdu-pe-eu1.private_subs"     = "10.17.64.0/24 10.17.65.0/24 10.17.66.0/24"
  "ritdu-pe-eu1.database_subs"    = "10.17.69.0/24 10.17.70.0/24 10.17.71.0/24"
  "ritdu-pe-eu1.elasticache_subs" = "10.17.74.0/24 10.17.75.0/24 10.17.76.0/24"
  "ritdu-pe-eu1.public_subs"      = "10.17.79.0/24 10.17.80.0/24 10.17.81.0/24"
  "ritdu-pe-eu1.region"           = "eu-west-1"
  "ritdu-pe-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-pe-eu1.account_id"       = "025015820777"

  "rimu.cidr"             = "172.16.64.0/19"
  "rimu.single_natgw"     = "true"
  "rimu.private_subs"     = "172.16.64.0/24 172.16.65.0/24 172.16.66.0/24"
  "rimu.database_subs"    = "172.16.69.0/24 172.16.70.0/24 172.16.71.0/24"
  "rimu.elasticache_subs" = "172.16.74.0/24 172.16.75.0/24 172.16.76.0/24"
  "rimu.public_subs"      = "172.16.79.0/24 172.16.80.0/24 172.16.81.0/24"
  "rimu.region"           = "eu-west-1"
  "rimu.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "rimu.account_id"       = "135132174985"

  "rimu-prop-vnm.cidr"             = "10.16.64.0/19"
  "rimu-prop-vnm.single_natgw"     = "true"
  "rimu-prop-vnm.private_subs"     = "10.16.64.0/24 10.16.65.0/24 10.16.66.0/24"
  "rimu-prop-vnm.database_subs"    = "10.16.69.0/24 10.16.70.0/24 10.16.71.0/24"
  "rimu-prop-vnm.elasticache_subs" = "10.16.74.0/24 10.16.75.0/24 10.16.76.0/24"
  "rimu-prop-vnm.public_subs"      = "10.16.79.0/24 10.16.80.0/24 10.16.81.0/24"
  "rimu-prop-vnm.region"           = "eu-west-1"
  "rimu-prop-vnm.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "rimu-prop-vnm.account_id"       = "348539006591"

  "ritdu-dcd.cidr"             = "10.15.64.0/19"
  "ritdu-dcd.single_natgw"     = "true"
  "ritdu-dcd.private_subs"     = "10.15.64.0/24 10.15.65.0/24 10.15.66.0/24"
  "ritdu-dcd.database_subs"    = "10.15.69.0/24 10.15.70.0/24 10.15.71.0/24"
  "ritdu-dcd.elasticache_subs" = "10.15.74.0/24 10.15.75.0/24 10.15.76.0/24"
  "ritdu-dcd.public_subs"      = "10.15.79.0/24 10.15.80.0/24 10.15.81.0/24"
  "ritdu-dcd.region"           = "eu-west-1"
  "ritdu-dcd.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-dcd.account_id"       = "634401859868"

  "roam-horizon-af1.cidr"             = "10.14.64.0/19"
  "roam-horizon-af1.single_natgw"     = "true"
  "roam-horizon-af1.private_subs"     = "10.14.64.0/24 10.14.65.0/24 10.14.66.0/24"
  "roam-horizon-af1.database_subs"    = "10.14.69.0/24 10.14.70.0/24 10.14.71.0/24"
  "roam-horizon-af1.elasticache_subs" = "10.14.74.0/24 10.14.75.0/24 10.14.76.0/24"
  "roam-horizon-af1.public_subs"      = "10.14.79.0/24 10.14.80.0/24 10.14.81.0/24"
  "roam-horizon-af1.region"           = "eu-west-1"
  "roam-horizon-af1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "roam-horizon-af1.account_id"       = "947872912714"

  "ritdu-cars-af1.cidr"             = "10.13.64.0/19"
  "ritdu-cars-af1.single_natgw"     = "true"
  "ritdu-cars-af1.private_subs"     = "10.13.64.0/24 10.13.65.0/24 10.13.66.0/24"
  "ritdu-cars-af1.database_subs"    = "10.13.69.0/24 10.13.70.0/24 10.13.71.0/24"
  "ritdu-cars-af1.elasticache_subs" = "10.13.74.0/24 10.13.75.0/24 10.13.76.0/24"
  "ritdu-cars-af1.public_subs"      = "10.13.79.0/24 10.13.80.0/24 10.13.81.0/24"
  "ritdu-cars-af1.region"           = "eu-west-1"
  "ritdu-cars-af1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-cars-af1.account_id"       = "162950623938"

  "ritdu-jobs-af1.cidr"             = "10.12.64.0/19"
  "ritdu-jobs-af1.single_natgw"     = "true"
  "ritdu-jobs-af1.private_subs"     = "10.12.64.0/24 10.12.65.0/24 10.12.66.0/24"
  "ritdu-jobs-af1.database_subs"    = "10.12.69.0/24 10.12.70.0/24 10.12.71.0/24"
  "ritdu-jobs-af1.elasticache_subs" = "10.12.74.0/24 10.12.75.0/24 10.12.76.0/24"
  "ritdu-jobs-af1.public_subs"      = "10.12.79.0/24 10.12.80.0/24 10.12.81.0/24"
  "ritdu-jobs-af1.region"           = "eu-west-1"
  "ritdu-jobs-af1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-jobs-af1.account_id"       = "471953789682"

  "cube-sdc-eu1.cidr"             = "10.19.64.0/19"
  "cube-sdc-eu1.single_natgw"     = "true"
  "cube-sdc-eu1.private_subs"     = "10.19.64.0/24 10.19.65.0/24 10.19.66.0/24"
  "cube-sdc-eu1.database_subs"    = "10.19.69.0/24 10.19.70.0/24 10.19.71.0/24"
  "cube-sdc-eu1.elasticache_subs" = "10.19.74.0/24 10.19.75.0/24 10.19.76.0/24"
  "cube-sdc-eu1.public_subs"      = "10.19.79.0/24 10.19.80.0/24 10.19.81.0/24"
  "cube-sdc-eu1.region"           = "eu-west-1"
  "cube-sdc-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "cube-sdc-eu1.account_id"       = "013389100338"

  "ritdu-qme-eu1.cidr"             = "10.20.64.0/19"
  "ritdu-qme-eu1.single_natgw"     = "true"
  "ritdu-qme-eu1.private_subs"     = "10.20.64.0/24 10.20.65.0/24 10.20.66.0/24"
  "ritdu-qme-eu1.database_subs"    = "10.20.69.0/24 10.20.70.0/24 10.20.71.0/24"
  "ritdu-qme-eu1.elasticache_subs" = "10.20.74.0/24 10.20.75.0/24 10.20.76.0/24"
  "ritdu-qme-eu1.public_subs"      = "10.20.79.0/24 10.20.80.0/24 10.20.81.0/24"
  "ritdu-qme-eu1.region"           = "eu-west-1"
  "ritdu-qme-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-qme-eu1.account_id"       = "474619220437"

  "ritdu-hex-eu1.cidr"             = "10.21.64.0/19"
  "ritdu-hex-eu1.single_natgw"     = "true"
  "ritdu-hex-eu1.private_subs"     = "10.21.64.0/24 10.21.65.0/24 10.21.66.0/24"
  "ritdu-hex-eu1.database_subs"    = "10.21.69.0/24 10.21.70.0/24 10.21.71.0/24"
  "ritdu-hex-eu1.elasticache_subs" = "10.21.74.0/24 10.21.75.0/24 10.21.76.0/24"
  "ritdu-hex-eu1.public_subs"      = "10.21.79.0/24 10.21.80.0/24 10.21.81.0/24"
  "ritdu-hex-eu1.region"           = "eu-west-1"
  "ritdu-hex-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-hex-eu1.account_id"       = "592990123379"

  "ritdu-cars-af1.cidr"             = "10.22.64.0/19"
  "ritdu-cars-af1.single_natgw"     = "true"
  "ritdu-cars-af1.private_subs"     = "10.22.64.0/24 10.22.65.0/24 10.22.66.0/24"
  "ritdu-cars-af1.database_subs"    = "10.22.69.0/24 10.22.70.0/24 10.22.71.0/24"
  "ritdu-cars-af1.elasticache_subs" = "10.22.74.0/24 10.22.75.0/24 10.22.76.0/24"
  "ritdu-cars-af1.public_subs"      = "10.22.79.0/24 10.22.80.0/24 10.22.81.0/24"
  "ritdu-cars-af1.region"           = "eu-west-1"
  "ritdu-cars-af1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-cars-af1.account_id"       = "162950623938"

  "ritdu-meta-eu1.cidr"             = "10.23.64.0/19"
  "ritdu-meta-eu1.single_natgw"     = "true"
  "ritdu-meta-eu1.private_subs"     = "10.23.64.0/24 10.23.65.0/24 10.23.66.0/24"
  "ritdu-meta-eu1.database_subs"    = "10.23.69.0/24 10.23.70.0/24 10.23.71.0/24"
  "ritdu-meta-eu1.elasticache_subs" = "10.23.74.0/24 10.23.75.0/24 10.23.76.0/24"
  "ritdu-meta-eu1.public_subs"      = "10.23.79.0/24 10.23.80.0/24 10.23.81.0/24"
  "ritdu-meta-eu1.region"           = "eu-west-1"
  "ritdu-meta-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-meta-eu1.account_id"       = "132631306742"

  "ritdu-bi-eu1.cidr"             = "10.24.64.0/19"
  "ritdu-bi-eu1.single_natgw"     = "true"
  "ritdu-bi-eu1.private_subs"     = "10.24.64.0/24 10.24.65.0/24 10.24.66.0/24"
  "ritdu-bi-eu1.database_subs"    = "10.24.69.0/24 10.24.70.0/24 10.24.71.0/24"
  "ritdu-bi-eu1.elasticache_subs" = "10.24.74.0/24 10.24.75.0/24 10.24.76.0/24"
  "ritdu-bi-eu1.public_subs"      = "10.24.79.0/24 10.24.80.0/24 10.24.81.0/24"
  "ritdu-bi-eu1.region"           = "eu-west-1"
  "ritdu-bi-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-bi-eu1.account_id"       = "981242785456"

  "ritdu-mkt-eu1.cidr"             = "10.25.64.0/19"
  "ritdu-mkt-eu1.single_natgw"     = "true"
  "ritdu-mkt-eu1.private_subs"     = "10.25.64.0/24 10.25.65.0/24 10.25.66.0/24"
  "ritdu-mkt-eu1.database_subs"    = "10.25.69.0/24 10.25.70.0/24 10.25.71.0/24"
  "ritdu-mkt-eu1.elasticache_subs" = "10.25.74.0/24 10.25.75.0/24 10.25.76.0/24"
  "ritdu-mkt-eu1.public_subs"      = "10.25.79.0/24 10.25.80.0/24 10.25.81.0/24"
  "ritdu-mkt-eu1.region"           = "eu-west-1"
  "ritdu-mkt-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-mkt-eu1.account_id"       = "032310891895"

  "ritdu-ecom-eu1.cidr"             = "10.26.64.0/19"
  "ritdu-ecom-eu1.single_natgw"     = "true"
  "ritdu-ecom-eu1.private_subs"     = "10.26.64.0/24 10.26.65.0/24 10.26.66.0/24"
  "ritdu-ecom-eu1.database_subs"    = "10.26.69.0/24 10.26.70.0/24 10.26.71.0/24"
  "ritdu-ecom-eu1.elasticache_subs" = "10.26.74.0/24 10.26.75.0/24 10.26.76.0/24"
  "ritdu-ecom-eu1.public_subs"      = "10.26.79.0/24 10.26.80.0/24 10.26.81.0/24"
  "ritdu-ecom-eu1.region"           = "eu-west-1"
  "ritdu-ecom-eu1.azs"              = "eu-west-1a eu-west-1b eu-west-1c"
  "ritdu-ecom-eu1.account_id"       = "102891362269"




}

key_pair_public = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaDnF2AhXZyX6wGz3JXIX27Ix3kEoGfqO1DsDfnJ66xlV+LVq+j6hmYWrED6tUI7Bj6UNiGi1UXOaTvI9tGcpUgEigyIJLUWSptzxIXQCf+/YVvmhVqKk2wbRrJmP5z9zPj3JLuLjaygci1KeuoJAx10CSzMX8zVCXXB68dAeDE1hcIYU2pSMBnF2y5HHg3UT3A8mpIuW/raZR0Ic+dHXqHUgWye2IisZrLXshRjW1W9jxVNpUOgFhJl2VJCNGb21sZ+FXhL4St0TNtRDBzhpPBQrNuXcTneC8JG5aLorw3jWwIpbubGcOFUnFG0x5UZZut1bKFaw2NxDInhQHQeNcgjPBhoyd5WjDP/xa1DV7DwK5K5eyfBwTYHX2FpWxHzA6Vg+1dgT4kEz9vXSTZn5UorYbM+SRPGA/OLCjetJ3j0eZKYMtYWBJjhpenFTAvJNbjyiN6C9dnBRcotEhE1CcEtyZaIF3dUWHtCZN8j/T5uPFXKx9wuc2jhwTY3wcDCpqf0G9LXffyxNK6RtPdew4A6Awc3CNUqh8eyVwJ7p8lAJzo27nsHAIysc2/Y+Vc4aMK43vn9omBVd5GNWTZZIcB7nogacKp+pRA0aAduQFIHVBgYjkr3Ne3ZQ5EwsJhwtBhbVWuYfBB8ZIcBBN24Qqhaq8HJNQsBAcJ9sxOOKZ8w== staging@ringierimu"


