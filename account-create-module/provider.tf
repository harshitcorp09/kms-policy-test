provider "aws" {
  alias  = "new_account_ap_northeast_1"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "shared_account_ap_northeast_1"
  region = "ap-northeast-1"
}
