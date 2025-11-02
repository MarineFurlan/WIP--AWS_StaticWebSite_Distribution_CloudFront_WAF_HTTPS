############################# ==== ROUTE 53 ==== #############################

### === Import existing hosted zone === ###
data "aws_route53_zone" "existing" {
  name         = var.domain
  private_zone = false
}

# Alias record "furlan-cloudsecurity.fr" vers CloudFront
resource "aws_route53_record" "root_alias" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = ""
  type    = "A" // IPv4

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }

}

# Alias record "www.furlan-cloudsecurity.fr"
resource "aws_route53_record" "www_alias" {
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = "www"
  type    = "A" // IPv4

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }

}