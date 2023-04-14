data "aws_route53_zone" "zone" {
  name = "demo.${var.domain_name}"
}

# Create Route53 A record
resource "aws_route53_record" "webapp_dns" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "demo.${var.domain_name}"
  type    = "A"
  //ttl     = "600"

  //records = [
     // "${aws_eip.myApp_eip[0].public_ip}"
  //]

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}



# Create Route53 record for www subdomain
resource "aws_route53_record" "www_dns" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "www.demo.${var.domain_name}"
  type    = "A"
  //ttl     = "600"

  //records = [
  //  "${aws_eip.myApp_eip[0].public_ip}"
  //]

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

data "aws_acm_certificate" "mycert" {
  domain   = "demo.mariaobono.me"
  
}

output "mycert_arn" {
  value = data.aws_acm_certificate.mycert.arn
}

output "ns-servers" {
  value = "${data.aws_route53_zone.zone.name_servers}"
}
output "web_public_ip" {
  description = "The public IP address of the web server"

  //we are grabbing it from the Elastic IP
  value = aws_eip.myApp_eip[0].public_ip

  //this output waits for the Elastic IPS to be created and distributed

  depends_on = [
    aws_eip.myApp_eip
  ]
}

output "web_public_dns" {
  description = "The public DNS address on the web server"

  value = aws_eip.myApp_eip[0].public_dns

  depends_on = [
    aws_eip.myApp_eip
  ]
}
