terraform {
  backend "s3" {
    bucket = "terraform-visual-september"
    key    = "eks/infrastructure/external-dns.tfstate"
    region = "us-east-1"
  }
}