provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      AppName    = "HR Automation"
      CostCenter = "JHC777"
    }
  }

}