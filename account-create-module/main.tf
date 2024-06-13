module "foundational_resources_module_ap_northeast_1" {
  source  = "./../foundational-resources-module"

  providers = {
    aws        = aws.new_account_ap_northeast_1
    aws.shared = aws.shared_account_ap_northeast_1
  }

  count                        = local.deploy_resources_ap_northeast_1 ? 1 : 0
  security_prod_acct_number    = var.security_prod_acct_number
  shared_prod_acct_number      = var.shared_prod_acct_number
  shared_services_cwe_bus_role = module.foundational_roles_module.shared_services_cwebus_role_arn
  sec_services_cwe_bus_Role    = module.foundational_roles_module.sec_services_cwebus_role_arn
  new_account_number           = aws_organizations_account.account.id
  new_account                  = true
  vpc_ids                      = [data.aws_vpc.vpc_id_ap_northeast_1[count.index].id]
  vpc_cidrs                    = [data.aws_vpc.vpc_id_ap_northeast_1[count.index].cidr_block]
  shared_tags                  = var.shared_tags
  region                       = local.region_ap_northeast_1

  depends_on = [data.aws_lambda_invocation.remove_default_vpc_resources, module.foundational_roles_module, data.aws_lambda_invocation.move_account_target_ou]
}
