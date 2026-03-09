##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  functions_names = {
    for key, function in var.functions : key => format("%s-%s-function", key, local.cloudfront_name_short)
  }
}

resource "aws_cloudfront_function" "this" {
  for_each = var.functions
  name     = local.functions_names[each.key]
  comment  = try(each.value.comment, format("CloudFront function %s for %s", each.key, local.cloudfront_name))
  runtime  = try(each.value.runtime, "cloudfront-js-2.0")
  publish  = try(each.value.publish, true)
  code     = each.value.code
}
