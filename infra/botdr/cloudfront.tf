resource "aws_cloudfront_distribution" "cf_dist_botdr_web" {
  #checkov:skip=CKV2_AWS_47
  #checkov:skip=CKV_AWS_68
  #checkov:skip=CKV_AWS_310
  #checkov:skip=CKV_AWS_86
  origin {
    domain_name              = aws_s3_bucket.web_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = "${var.env}-botdr-web-s3-oid"
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "${var.env}-botdr-web-cf-dist"
  default_root_object = "index.html"

  aliases = var.env == "dev" ? ["${lower(var.env)}.${data.aws_route53_zone.botdr_zone.name}"] : [data.aws_route53_zone.botdr_zone.name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.env}-botdr-web-s3-oid"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    response_headers_policy_id = aws_cloudfront_response_headers_policy.default.id
    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = 300
    max_ttl                    = 3600
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = [
        "US",
        "CA"
      ]
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.web_cert.arn
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${lower(var.env)}-botdr-cf-pri-site-oac"
  description                       = "default cf origin access control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "default" {
  name    = "${lower(var.env)}-botdr-cf-pri-site-resp-hdrs-pol"
  comment = "Cloudfront response headers policy for environment ${var.env}"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
      preload                    = true
    }
  }

  cors_config {
    access_control_allow_credentials = true

    access_control_allow_headers {
      items = [
        "X-Custom-Header",
        "Upgrade-Insecure-Requests"
      ]
    }

    access_control_allow_methods {
      items = [
        "GET",
        "POST"
      ]
    }

    access_control_allow_origins {
      items = [
        "*"
      ]
    }

    origin_override = true
  }
}
