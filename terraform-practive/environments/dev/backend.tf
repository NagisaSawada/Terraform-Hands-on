terraform {
  backend "s3" {
    bucket = "terraform-practice-891377143345"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

