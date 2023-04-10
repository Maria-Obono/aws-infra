data "aws_route53_zone" "zone" {
  name = "demo.${var.domain_name}"
   private_zone = false
}

# Create Route53 A record alias for the load balancer
resource "aws_route53_record" "webapp_dns" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "demo.${var.domain_name}"
  type    = "A"
  
 
alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = false
   
  }
 
}

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.zone.zone_id
}
resource "aws_acm_certificate" "api" {
  domain_name       = "demo.${var.domain_name}"
  validation_method = "DNS"
}
resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]

}

output "ns-servers" {
  value = "${data.aws_route53_zone.zone.name_servers}"
}
output "web_public_ip" {
  description = "The public IP address of the web server"
  value = aws_lb.load_balancer.dns_name
}

output "web_public_dns" {
  description = "The public DNS address on the web server"

  value = aws_lb.load_balancer.dns_name

}
