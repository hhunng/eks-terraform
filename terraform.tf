terraform {
  backend "s3" {
    bucket = "tfstate-evangelion"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}