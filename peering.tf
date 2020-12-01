# # peering request has first to come from rimu-tf-base before this config can run!



# locals {
#   workspace_map = {
#     prod = 0
#   }
# }

# resource "aws_vpc_peering_connection_accepter" "base" {
#   count                     = terraform.workspace == "prod" ? 1 : 0
#   vpc_peering_connection_id = data.terraform_remote_state.core_base.outputs.ritdu_ecom_eu1_peering_ids[0][local.workspace_map["prod"]]
#   auto_accept               = true

#   tags = {
#     Name        = "${var.app_name}/${terraform.workspace} <> core/base"
#     App         = var.app_name
#     Environment = terraform.workspace
#     Side        = "Accepter"
#   }
# }

# # value = terraform.workspace != "qa" ? aws_ecs_cluster.main[0].id : null

# resource "aws_route" "base_vpc_peering_private" {
#   count = terraform.workspace == "prod" ? length(module.main_vpc.private_route_table_ids) : 0

#   route_table_id            = element(module.main_vpc.private_route_table_ids, count.index)
#   destination_cidr_block    = data.terraform_remote_state.core_env.outputs.main_vpc_cidr
#   vpc_peering_connection_id = data.terraform_remote_state.core_base.outputs.ritdu_ecom_eu1_peering_ids[0][local.workspace_map["prod"]]
# }

# resource "aws_route" "base_vpc_peering_public" {
#   count = terraform.workspace == "prod" ? length(module.main_vpc.public_route_table_ids) : 0

#   route_table_id            = element(module.main_vpc.public_route_table_ids, count.index)
#   destination_cidr_block    = data.terraform_remote_state.core_env.outputs.main_vpc_cidr
#   vpc_peering_connection_id = data.terraform_remote_state.core_base.outputs.ritdu_ecom_eu1_peering_ids[0][local.workspace_map["prod"]]
# }