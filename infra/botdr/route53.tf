resource "aws_route53_record" "botdr_web" {
  zone_id = data.aws_route53_zone.botdr_zone.zone_id
  name    = var.env == "dev" ? "${lower(var.env)}.${data.aws_route53_zone.botdr_zone.name}" : data.aws_route53_zone.botdr_zone.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_dist_botdr_web.domain_name
    zone_id                = aws_cloudfront_distribution.cf_dist_botdr_web.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "web_cert_val_record" {
  for_each = {
    for dvo in aws_acm_certificate.web_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.botdr_zone.zone_id
}
