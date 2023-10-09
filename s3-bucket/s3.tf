provider "aws" {               # Defines where we are getting the resources from
   region = var.region         # Defines where the resources below will be created
}

resource "random_integer" "suffix" {
  min = 10
  max = 99
}

resource "aws_s3_bucket" "s3" {                        # Resource type; alias for resource block. Think git and remote repo alias
  bucket = "bootcamp32-${var.env}-${random_integer.suffix.result}"

  tags = {
    Name = "backend"
    env  = var.env
  }
}

resource "aws_kms_key" "kms" {
  description             = "KMS key bootcamp32"
  deletion_window_in_days = 10
}