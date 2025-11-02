terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

##################################### ==== CLOUDFRONT ==== #####################################

// Required to grant CloudFront access to a private s3 bucket
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-${var.domain}"
  description                       = "OAC for ${var.domain}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

### === CloudFront distribution with OAC === ###
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = [var.domain, "www.${var.domain}"]

  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = "s3-${var.s3_bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-${var.s3_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class      = var.price_class
  default_root_object = "index.html"
  web_acl_id       = var.waf_acl_arn
}


