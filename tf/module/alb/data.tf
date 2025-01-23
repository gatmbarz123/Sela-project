data "aws_route53_zone" "hosted_zone_id" {
  name = var.route53_zone_name
}