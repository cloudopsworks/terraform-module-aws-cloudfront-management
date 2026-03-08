##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  cloudfront_name = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name)
}
resource "aws_cloudfront_distribution" "this" {
  enabled = try(var.settings.enabled, true)
  is_ipv6_enabled = try(var.settings.ipv6_enabled, false)
    comment = try(var.settings.comment, local.cloudfront_name)
  default_root_object = try(var.settings.default_root_object, "index.html")
  aliases = try(var.settings.aliases, [])
  viewer_certificate {
    cloudfront_default_certificate = try(var.settings.cert.cloudfront_default_certificate, true)
    acm_certificate_arn            = try(var.acm_certificate_arn, null)
    minimum_protocol_version        = try(var.settings.cert.minimum_protocol_version, null)
    ssl_support_method              = try(var.settings.cert.ssl_support_method, null)
  }
  tags    = merge(local.all_tags, {
    "Name" = local.cloudfront_name
  })
}
