resource "aws_acm_certificate" "web_cert" {
  domain_name       = data.aws_route53_zone.botdr_zone.name
  validation_method = "DNS"
  subject_alternative_names = [
    var.env == "dev" ? "${lower(var.env)}.${data.aws_route53_zone.botdr_zone.name}" : data.aws_route53_zone.botdr_zone.name
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "web_cert_val" {
  certificate_arn = aws_acm_certificate.web_cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.web_cert_val_record : record.fqdn
  ]
}
