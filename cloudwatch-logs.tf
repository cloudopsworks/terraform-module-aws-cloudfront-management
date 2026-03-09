##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  cloudwatch_log_group_name = format("/aws/cloudfront/%s", local.cloudfront_name)
}

import {
  id = local.cloudwatch_log_group_name
  to = aws_cloudwatch_log_group.this
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.cloudwatch_log_group_name
  skip_destroy      = try(var.settings.logs.skip_destroy, true)
  retention_in_days = try(var.settings.logs.retention_in_days, 7)
  tags              = local.all_tags
}