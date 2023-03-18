resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

# Create Route53 A record
resource "aws_route53_record" "webapp_dns" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = var.domain_name
  type    = "A"
  ttl     = "600"

  records = [
    "${aws_instance.web_application[0].private_ip}"
  ]
}



# Create Route53 record for www subdomain
resource "aws_route53_record" "www_dns" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = "600"

  records = [
    "${aws_eip.myApp_eip[0].public_ip}"
  ]
}

output "ns-servers" {
  value = "${aws_route53_zone.zone.name_servers}"
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
