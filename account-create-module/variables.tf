variable "security_prod_acct_number" {
  type = string
}

variable "shared_prod_acct_number" {
  type = string
}

variable "shared_services_cwe_bus_role" {
  type = string
}

variable "sec_services_cwe_bus_Role" {
  type = string
}

variable "new_account_number" {
  type = string
}

variable "shared_tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "deploy_resources_ap_northeast_1" {
  type = bool
  default = true
}
