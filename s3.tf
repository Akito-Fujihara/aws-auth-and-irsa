resource "aws_s3_bucket" "node_role_access" {
  bucket = "node-role-access-bucket"
}

resource "aws_s3_bucket" "irsa_access" {
  bucket = "irsa-access-bucket"
}
