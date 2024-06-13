variable "shared_tags" {
  type = map(string)
}

variable "additional_ebs_kms_policies" {
  type = list(string)
}

variable "new_account_number" {
  type = string
}

variable "region" {
  type = string
}
