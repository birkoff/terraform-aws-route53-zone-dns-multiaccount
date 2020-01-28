resource "aws_route53_zone" "public-child" {
  name    = "${lookup(var.hosted_zone_names, "public-child")}"
  comment = "public-child zone"

  tags = "${var.tags}"
}

resource "aws_route53_record" "public-child-ns" {
  provider = "aws.ops"
  zone_id  = "${lookup(local.public_hosted_zones, "public-parent")}"
  name     = "${lookup(var.hosted_zone_names, "public-child")}"
  type     = "NS"
  ttl      = "30"

  records = [
    "${aws_route53_zone.public-child.name_servers.0}",
    "${aws_route53_zone.public-child.name_servers.1}",
    "${aws_route53_zone.public-child.name_servers.2}",
    "${aws_route53_zone.public-child.name_servers.3}",
  ]
}


output "hosted_zone_ids" {
  value = {
    public  = "${aws_route53_zone.public-child.zone_id}"
  }
}

output "hosted_zone_names" {
  value = {
    public  = "${aws_route53_zone.public-child.name}"
  }
}
