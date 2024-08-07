data "aws_route53_zone" "main" {
  provider     = aws.dns
  name         = var.main_hosted_zone_name
  private_zone = false
}