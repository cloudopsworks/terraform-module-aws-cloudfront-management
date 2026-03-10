##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  stg_cloudfront_name       = var.name != "" ? var.name : format("%s-%s-stg", var.name_prefix, local.system_name)
  stg_cloudfront_name_short = var.name != "" ? var.name : format("%s-%s-stg", var.name_prefix, local.system_name_short)
}

resource "aws_cloudfront_origin_access_control" "staging" {
  for_each = {
    for key, origin in try(var.settings.origins, {}) : key => origin
    if try(var.settings.staging.create, false)
  }
  name                              = format("%s-%s-stg-oac", each.key, local.stg_cloudfront_name_short)
  origin_access_control_origin_type = each.value.type == "s3" ? "s3" : "custom"
  signing_behavior                  = try(each.value.signing_behavior, "always")
  signing_protocol                  = try(each.value.signing_protocol, "sigv4")
}

resource "aws_cloudfront_distribution" "staging" {
  count               = try(var.settings.staging.create, false) ? 1 : 0
  staging             = true
  enabled             = try(var.settings.staging.enabled, true)
  is_ipv6_enabled     = try(var.settings.ipv6_enabled, false)
  comment             = try(var.settings.comment, format("Staging CloudFront distribution for %s", local.cloudfront_name))
  default_root_object = try(var.settings.default_root_object, "index.html")
  viewer_certificate {
    cloudfront_default_certificate = try(var.acm_certificate_arn, "") == "" ? try(var.settings.cert.cloudfront_default_certificate, true) : false
    acm_certificate_arn            = try(var.acm_certificate_arn, null)
    minimum_protocol_version       = try(var.settings.cert.minimum_protocol_version, "TLSv1.2_2025")
    ssl_support_method             = try(var.settings.cert.ssl_support_method, "sni-only")
  }
  default_cache_behavior {
    allowed_methods        = try(var.settings.default_cache_behavior.allowed_methods, ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
    cached_methods         = try(var.settings.default_cache_behavior.cached_methods, ["GET", "HEAD"])
    target_origin_id       = try(var.settings.default_cache_behavior.target_origin_id, format("%s-%s", var.settings.default_origin, local.cloudfront_name_short))
    viewer_protocol_policy = try(var.settings.default_cache_behavior.viewer_protocol_policy, "redirect-to-https")
    min_ttl                = try(var.settings.default_cache_behavior.min_ttl, null)
    default_ttl            = try(var.settings.default_cache_behavior.default_ttl, null)
    max_ttl                = try(var.settings.default_cache_behavior.max_ttl, null)
    compress               = try(var.settings.default_cache_behavior.compress, true)
    cache_policy_id        = data.aws_cloudfront_cache_policy.this.id
    dynamic "function_association" {
      for_each = try(var.settings.default_cache_behavior.functions, [])
      content {
        function_arn = try(function_association.value.ref) != "" ? aws_cloudfront_function.this[function_association.value.ref].arn : function_association.value.function_arn
        event_type   = function_association.value.event_type
      }
    }
  }
  dynamic "origin" {
    for_each = try(var.settings.origins, {})
    content {
      domain_name              = origin.value.type == "s3" ? data.aws_s3_bucket.s3_origin[origin.key].bucket_regional_domain_name : origin.value.domain_name
      origin_id                = format("%s-%s", origin.key, local.cloudfront_name_short)
      origin_path              = try(origin.value.origin_staging_path, origin.value.origin_path, null)
      origin_access_control_id = aws_cloudfront_origin_access_control.staging[origin.key].id
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = try(var.settings.restrictions.restriction_type, "none")
      locations        = try(var.settings.restrictions.locations, [])
    }
  }
  tags = merge(local.all_tags, {
    "Name" = local.stg_cloudfront_name
  })
}

resource "aws_cloudfront_continuous_deployment_policy" "staging" {
  count   = try(var.settings.staging.create, false) ? 1 : 0
  enabled = true
  staging_distribution_dns_names {
    items    = [aws_cloudfront_distribution.staging[0].domain_name]
    quantity = 1
  }
  traffic_config {
    type = length(try(var.settings.staging.header, {})) > 0 ? "SingleHeader" : "SingleWeight"
    dynamic "single_header_config" {
      for_each = length(try(var.settings.staging.header, {})) > 0 ? [1] : []
      content {
        header = var.settings.staging.header.name
        value  = var.settings.staging.header.value
      }
    }
    dynamic "single_weight_config" {
      for_each = length(try(var.settings.staging.header, {})) > 0 ? [] : [1]
      content {
        weight = (var.settings.weighted.traffic_percent / 100)
        dynamic "session_stickiness_config" {
          for_each = try(var.settings.weighted.session_stickiness.enabled, false) ? [1] : []
          content {
            idle_ttl    = try(var.settings.weighted.session_stickiness.idle_ttl, 300)
            maximum_ttl = try(var.settings.weighted.session_stickiness.maximum_ttl, 300)
          }
        }
      }
    }
  }
}

resource "aws_cloudfront_continuous_deployment_policy" "weight" {
  count   = try(var.settings.staging.create, false) && length(try(var.settings.staging.weighted, {})) > 0 ? 1 : 0
  enabled = true
  staging_distribution_dns_names {
    items    = [aws_cloudfront_distribution.staging[0].domain_name]
    quantity = 1
  }
  traffic_config {
    type = "SingleWeight"
    single_header_config {
      header = var.settings.staging.header.name
      value  = var.settings.staging.header.value
    }
  }
}
