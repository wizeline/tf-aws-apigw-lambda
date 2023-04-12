output "hosted_zone_id" {
  value = data.aws_route53_zone.this.zone_id
}

output "certificate_arn" {
  value = join("", aws_acm_certificate.this.*.arn)
}