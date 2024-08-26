### S3
resource "random_string" "bucket_random" {
  length           = 4
  upper   = false
  lower   = false
  numeric  = true
  special = false
}

resource "aws_s3_bucket" "source" {
  provider = aws.seoul
  bucket   = "day3-app-${random_string.bucket_random.result}"
}

locals {
  filepath = "./app"
}

resource "aws_s3_object" "token" {
  bucket = aws_s3_bucket.source.id
  key    = "/token-app/token"
  source = "${local.filepath}/token-app/token"
  etag   = filemd5("${local.filepath}/token-app/token")
  content_type = "application/octet-stream"
}

resource "aws_s3_object" "employees" {
  bucket = aws_s3_bucket.source.id
  key    = "/employees-app/employees"
  source = "${local.filepath}/employees-app/employees"
  etag   = filemd5("${local.filepath}/employees-app/employees")
  # content_type = "application/octet-stream"
}
resource "aws_s3_object" "token-Dockerfile" {
  bucket = aws_s3_bucket.source.id
  key    = "/token-app/Dockerfile"
  source = "${local.filepath}/token-app/Dockerfile"
  etag   = filemd5("${local.filepath}/token-app/Dockerfile")
}
resource "aws_s3_object" "employees-Dockerfile" {
  bucket = aws_s3_bucket.source.id
  key    = "/employees-app/Dockerfile"
  source = "${local.filepath}/employees-app/Dockerfile"
  etag   = filemd5("${local.filepath}/employees-app/Dockerfile")
}
resource "aws_s3_object" "cwagnet-emp" {
  bucket = aws_s3_bucket.source.id
  key    = "/employees-app/cwagent.json"
  source = "./src/cwagent(emp).json"
  etag   = filemd5("./src/cwagent(emp).json")
}
resource "aws_s3_object" "cwagnet-token" {
  bucket = aws_s3_bucket.source.id
  key    = "/token-app/cwagent.json"
  source = "./src/cwagent(token).json"
  etag   = filemd5("./src/cwagent(token).json")
}

resource "aws_s3_object" "deployment" {
  bucket = aws_s3_bucket.source.id
  key    = "/yaml/deployment.yaml"
  source = "${local.filepath}/yaml/deployment.yaml"
  etag   = filemd5("${local.filepath}/yaml/deployment.yaml")
}

resource "aws_s3_object" "service" {
  bucket = aws_s3_bucket.source.id
  key    = "/yaml/service.yaml"
  source = "${local.filepath}/yaml/service.yaml"
  etag   = filemd5("${local.filepath}/yaml/service.yaml")
}

resource "aws_s3_object" "envoy_emp" {
  bucket = aws_s3_bucket.source.id
  key    = "/envoy/emp_config.yml"
  source = "${local.filepath}/envoy/emp_config.yml"
  etag   = filemd5("${local.filepath}/envoy/emp_config.yml")
}

resource "aws_s3_object" "envoy_token" {
  bucket = aws_s3_bucket.source.id
  key    = "/envoy/token_config.yml"
  source = "${local.filepath}/envoy/token_config.yml"
  etag   = filemd5("${local.filepath}/envoy/token_config.yml")
}
resource "aws_s3_object" "hpa" {
  bucket = aws_s3_bucket.source.id
  key    = "/yaml/hpa.yaml"
  source = "${local.filepath}/yaml/hpa.yaml"
  etag   = filemd5("${local.filepath}/yaml/hpa.yaml")
}