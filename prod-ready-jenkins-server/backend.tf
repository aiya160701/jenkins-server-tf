terraform {
  backend "s3" {
    bucket  = "my-jenkins-backend-bucket-aiya"
    key     = "prod-ready-jenkins-server/prod-network/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}