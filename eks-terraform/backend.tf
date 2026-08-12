# terraform {
#   backend "s3" {
#     bucket = "terraform-statefile-eks-devsecops-us-east-2" // Replace with your actual S3 bucket name
#     key    = "eks/terraform.tfstate"
#     region = "us-east-2" // You might have issues deploying this in N.Virginia, I'll suggest you use a different Region
#   }
# }
