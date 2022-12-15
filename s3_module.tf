/* module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket_prefix = "logs-${var.vpc_name}-"
  force_destroy = true

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

  tags = {
    LAB   = "tesi_mattia"
    infra = "terraform"
  }
}
*/
