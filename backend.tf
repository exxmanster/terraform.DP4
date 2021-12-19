terraform {
  backend "s3" {
    bucket = "terraform-backend.dp4"
    key    = "terraform/backend"
    region = "eu-central-1"
  }
}