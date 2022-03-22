resource "aws_route53_record" "private-record" {
  zone_id = var.PRIVATE_HOSTED_ZONE_ID
  name    = "${var.DB_COMPONENT}-${var.ENV}.devops.internal"
  type    = "A"
  ttl     = "300"
  records = [aws_spot_instance_request.db.private_ip]
}