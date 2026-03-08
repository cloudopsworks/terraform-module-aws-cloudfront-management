##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  cloudfront_name       = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name)
  cloudfront_name_short = var.name != "" ? var.name : format("%s-%s", var.name_prefix, local.system_name_short)
}
resource "aws_cloudfront_distribution" "this" {
  enabled             = try(var.settings.enabled, true)
  is_ipv6_enabled     = try(var.settings.ipv6_enabled, false)
  comment             = try(var.settings.comment, local.cloudfront_name)
  default_root_object = try(var.settings.default_root_object, "index.html")
  aliases             = try(var.settings.aliases, [])
  viewer_certificate {
    cloudfront_default_certificate = try(var.settings.cert.cloudfront_default_certificate, true)
    acm_certificate_arn            = try(var.acm_certificate_arn, null)
    minimum_protocol_version       = try(var.settings.cert.minimum_protocol_version, null)
    ssl_support_method             = try(var.settings.cert.ssl_support_method, null)
  }
  default_cache_behavior {
    allowed_methods        = try(var.settings.default_cache_behavior.allowed_methods, ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
    cached_methods         = try(var.settings.default_cache_behavior.cached_methods, ["GET", "HEAD"])
    target_origin_id       = try(var.settings.default_cache_behavior.target_origin_id, format("origin-%s", local.cloudfront_name_short))
    viewer_protocol_policy = try(var.settings.default_cache_behavior.viewer_protocol_policy, "redirect-to-https")
    min_ttl                = try(var.settings.default_cache_behavior.min_ttl, 0)
    default_ttl            = try(var.settings.default_cache_behavior.default_ttl, 3600)
    max_ttl                = try(var.settings.default_cache_behavior.max_ttl, 86400)
    forwarded_values {
      query_string = try(var.settings.default_cache_behavior.forwarded_values.query_string, false)
      cookies {
        forward           = try(var.settings.default_cache_behavior.forwarded_values.cookies.forward, "none")
        whitelisted_names = try(var.settings.default_cache_behavior.forwarded_values.cookies.whitelisted_names, [])
      }
      headers                 = try(var.settings.default_cache_behavior.forwarded_values.headers, [])
      query_string_cache_keys = try(var.settings.default_cache_behavior.forwarded_values.query_string_cache_keys, [])
    }
  }
  dynamic "origin" {
    for_each = try(var.settings.origins, {})
    content {
      domain_name = origin.value.domain_name
      origin_id   = format("%s-%s", origin.key, local.cloudfront_name_short)
      origin_path = try(origin.value.origin_path, null)
     }
  }
  restrictions {
    geo_restriction {
      restriction_type = try(var.settings.restrictions.restriction_type, "none")
      locations        = try(var.settings.restrictions.locations, [])
    }
  }
  tags = merge(local.all_tags, {
    "Name" = local.cloudfront_name
  })
}
