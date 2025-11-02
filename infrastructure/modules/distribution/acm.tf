########################################### ==== ACM ==== ###########################################

### === SSL CERTIFICATE GENERATION === ###
resource "aws_acm_certificate" "cert" {
  domain_name = var.domain   // like example.com
  validation_method = "DNS"
  subject_alternative_names = ["www.${var.domain}"]
  lifecycle { create_before_destroy = true }
}

### ===  DNS validation record in Route53 === ###
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.existing.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = values(aws_route53_record.validation)[*].fqdn
}