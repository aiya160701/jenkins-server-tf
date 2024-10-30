terraform {
  backend "s3" {
    bucket         = "my-jenkins-backend-bucket-aiya"
    key            = "session1/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}