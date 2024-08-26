resource "aws_cloudfront_cache_policy" "example" {
  name        = "day3-cdn-policy"
  comment     = "test"
  default_ttl = 50
  max_ttl     = 100
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["first_name","last_name"]
      }
    }
    enable_accept_encoding_gzip = false
    enable_accept_encoding_brotli = false
  }
}

resource "aws_cloudfront_distribution" "cf" {
  provider = aws.us-east-1

  origin {
    domain_name = aws_lb.day3-lb.dns_name
    origin_id   = aws_lb.day3-lb.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  comment         = "CloudFront For ALB"

  default_cache_behavior {
    target_origin_id       = aws_lb.day3-lb.id
    cache_policy_id        = aws_cloudfront_cache_policy.example.id
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    compress = true
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior {
    path_pattern             = "/v1/token"
    target_origin_id         = aws_lb.day3-lb.id
    cache_policy_id          = aws_cloudfront_cache_policy.example.id
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    compress = true
    viewer_protocol_policy = "allow-all"
  }

  ordered_cache_behavior {
    path_pattern             = "/v1/employee"
    target_origin_id         = aws_lb.day3-lb.id
    cache_policy_id          = aws_cloudfront_cache_policy.example.id
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    compress = true
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  web_acl_id = aws_wafv2_web_acl.waf.arn

  tags = {
    Name = "apdev-cdn"
  }
}

data "aws_iam_policy_document" "cloudfront_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudfront_example" {
  name               = "cloudfront-realtime-log-config-role"
  assume_role_policy = data.aws_iam_policy_document.cloudfront_assume_role.json
}

data "aws_iam_policy_document" "cloudfront_example" {
  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStreamSummary",
      "kinesis:DescribeStream",
      "kinesis:PutRecord",
      "kinesis:PutRecords",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudfront_example" {
  name   = "cloudfront-realtime-log-config-policy"
  role   = aws_iam_role.cloudfront_example.id
  policy = data.aws_iam_policy_document.cloudfront_example.json
}

resource "aws_cloudfront_realtime_log_config" "cloudfront_example" {
  name          = "CloudFrontRealTimeConfigName"
  sampling_rate = 100
  fields        = ["c-ip","sc-status","cs-host","cs-uri-stem","time-taken"]

  endpoint {
    stream_type = "Kinesis"

    kinesis_stream_config {
      role_arn   = aws_iam_role.cloudfront_example.arn
      stream_arn = aws_kinesis_stream.kds.arn
    }
  }

  depends_on = [aws_iam_role_policy.cloudfront_example,aws_kinesis_stream.kds,aws_iam_role.cloudfront_example]
}