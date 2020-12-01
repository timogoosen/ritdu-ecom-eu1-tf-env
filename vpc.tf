#
# VPC
#

################################################################################
# Resources
################################################################################
resource "aws_eip" "main_natgw" {
  count = local.main_vpc_single_natgw ? 1 : length(local.main_vpc_azs)
  vpc   = true

  tags = {
    # the name might not be acurate
    Name        = "${terraform.workspace}-main-vpc-natgw-${local.main_vpc_azs[count.index]}"
    App         = var.app_name
    Environment = terraform.workspace
  }
}

##########
# main vpc
##########
module "main_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = terraform.workspace == "prod" ? true : false

  name = "${terraform.workspace}-main-vpc"
  cidr = local.main_vpc_cidr

  azs                 = local.main_vpc_azs
  private_subnets     = local.main_vpc_private_subs
  database_subnets    = local.main_vpc_database_subs
  elasticache_subnets = local.main_vpc_elasticache_subs
  public_subnets      = local.main_vpc_public_subs

  enable_nat_gateway  = false
  reuse_nat_ips       = false
  #external_nat_ip_ids = "${aws_eip.main_natgw.*.id}"

  single_nat_gateway     = local.main_vpc_single_natgw
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_s3_endpoint   = false

  map_public_ip_on_launch = false

  #  Fargate EKS clusters will create tags on the shared subnets.
  #  This VPC module would otherwise replace those tags without the below equivelant tag.
  #  Ensure that var.eks_cluster_name matches the EKS cluster.
  #  Initially we only want QA eks cluster called eks-pb-cluster, but its
  #  ok for staging and prod to get the tags anyway.
  tags = {
    App                                             = var.app_name
    Environment                                     = terraform.workspace
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

################################################################################
# Outputs
################################################################################
output "main_vpc_id" {
  value = module.main_vpc.vpc_id
}

output "main_vpc_cidr" {
  value = module.main_vpc.vpc_cidr_block
}

# output "main_vpc_nat_public_ips" {
#   value = aws_eip.main_natgw.*.public_ip
# }

output "main_vpc_private_subnet_ids" {
  value = module.main_vpc.private_subnets
}

output "main_vpc_database_subnet_ids" {
  value = module.main_vpc.database_subnets
}

output "main_vpc_elasticache_subnet_ids" {
  value = module.main_vpc.elasticache_subnets
}

output "main_vpc_public_subnet_ids" {
  value = module.main_vpc.public_subnets
}

output "main_vpc_database_subnet_group_id" {
  value = module.main_vpc.database_subnet_group
}

output "main_vpc_elasticache_subnet_group_id" {
  value = module.main_vpc.elasticache_subnet_group
}

output "main_vpc_private_route_table_ids" {
  value = module.main_vpc.private_route_table_ids
}

output "main_vpc_public_route_table_ids" {
  value = module.main_vpc.public_route_table_ids
}

output "region" {
  value = local.main_vpc_region
}