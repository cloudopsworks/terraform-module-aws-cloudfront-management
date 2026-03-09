##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# name: "sample-distribution" # (Optional) The name of the CloudFront distribution. If not provided, a name will be generated using the name_prefix and system_name. Default: ""
variable "name" {
  description = "The name of the CloudFront distribution. If not provided, a name will be generated using the name_prefix and system_name."
  type        = string
  default     = ""
}

# name_prefix: "cdn" # (Optional) The prefix for the CloudFront distribution name. This is used to generate a name if the name variable is not provided. Default: ""
variable "name_prefix" {
  description = "The prefix for the CloudFront distribution name. This is used to generate a name if the name variable is not provided."
  type        = string
  default     = ""
}

# settings: # (Required) CloudFront distribution settings for the project.
#   enabled: true # (Optional) Whether the distribution is enabled to accept end user requests for content. Default: true
#   ipv6_enabled: false # (Optional) Whether IPv6 is enabled for the distribution. Default: false
#   comment: "CloudFront distribution" # (Optional) Any comments you want to include about the distribution. Default: "CloudFront distribution for <name>"
#   default_root_object: "index.html" # (Optional) The object that you want CloudFront to return when an end user requests the root URL. Default: "index.html"
#   aliases: ["example.com"] # (Optional) Extra CNAMEs (alternate domain names), if any, for this distribution. Default: []
#   default_origin: "my-origin" # (Required) The ID of the default origin for the distribution.
#   origins: # (Required) Map of origins for the distribution.
#     my-origin: # (Required) Unique identifier for the origin.
#       type: "s3" # (Required) The type of origin. Possible values: s3, custom.
#       name: "my-bucket" # (Required if type is s3) The name of the S3 bucket.
#       domain_name: "example.com" # (Required if type is custom) The DNS domain name of the origin.
#       origin_path: "/path" # (Optional) An optional element that causes CloudFront to request your content from a directory in your origin. Default: null
#       origin_staging_path: "/stg-path" # (Optional) An optional element that causes CloudFront to request your content from a directory in your origin for staging. Default: null
#       signing_behavior: "always" # (Optional) Specifies which requests CloudFront signs. Possible values: always, never, no-override. Default: "always"
#       signing_protocol: "sigv4" # (Optional) The protocol to use for signing requests. Default: "sigv4"
#   cert: # (Optional) Certificate settings for the distribution.
#     cloudfront_default_certificate: true # (Optional) true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name. Default: true (if acm_certificate_arn is not provided)
#     minimum_protocol_version: "TLSv1.2_2025" # (Optional) The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Default: "TLSv1.2_2025"
#     ssl_support_method: "sni-only" # (Optional) How you want CloudFront to serve HTTPS requests. Default: "sni-only"
#   default_cache_behavior: # (Required) Default cache behavior settings.
#     managed_cache: "Managed-CachingOptimized" # (Optional) The name of the managed cache policy to use. Default: "Managed-CachingOptimized"
#     allowed_methods: ["GET", "HEAD"] # (Optional) Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Default: ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#     cached_methods: ["GET", "HEAD"] # (Optional) Controls whether CloudFront caches the responses to requests using the specified HTTP methods. Default: ["GET", "HEAD"]
#     target_origin_id: "my-origin" # (Optional) The value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern. Default: derived from default_origin
#     viewer_protocol_policy: "redirect-to-https" # (Optional) Use this element to specify the protocol that users can use to access the files in the origin. Possible values: allow-all, https-only, redirect-to-https. Default: "redirect-to-https"
#     min_ttl: 0 # (Optional) The minimum amount of time that you want objects to stay in CloudFront caches. Default: null
#     default_ttl: 3600 # (Optional) The default amount of time that you want objects to stay in CloudFront caches. Default: null
#     max_ttl: 86400 # (Optional) The maximum amount of time that you want objects to stay in CloudFront caches. Default: null
#     compress: true # (Optional) Whether you want CloudFront to automatically compress certain files. Default: true
#     functions: # (Optional) List of function associations for the default cache behavior.
#       - ref: "my-func" # (Optional) Reference to a function defined in the functions variable.
#         function_arn: "arn:aws:cloudfront::..." # (Optional) The ARN of the CloudFront function.
#         event_type: "viewer-request" # (Required) The event type that triggers the function. Possible values: viewer-request, viewer-response.
#   restrictions: # (Optional) Restrictions settings for the distribution.
#     restriction_type: "none" # (Optional) The method that you want to use to restrict distribution of your content by country. Possible values: none, whitelist, blacklist. Default: "none"
#     locations: ["US", "CA"] # (Optional) The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content or not to distribute your content. Default: []
#   staging: # (Optional) Staging distribution settings.
#     create: false # (Optional) Whether to create a staging distribution. Default: false
#     enabled: true # (Optional) Whether the staging distribution is enabled. Default: true
#     header: # (Required if staging.create is true) Header configuration for traffic routing.
#       name: "X-Staging" # (Required if staging.create is true) The name of the header for traffic routing to staging.
#       value: "true" # (Required if staging.create is true) The value of the header for traffic routing to staging.
variable "settings" {
  description = "CloudFront distribution settings for the project. This variable should contain all the necessary configuration for the CloudFront distribution, such as origins, behaviors, and other settings."
  type        = any
  default     = {}
}

# functions: # (Optional) A map of CloudFront functions to be associated with the distribution.
#   my-func: # (Required) Unique identifier for the function.
#     comment: "My function" # (Optional) A comment for the function.
#     runtime: "cloudfront-js-2.0" # (Optional) The runtime for the function. Default: "cloudfront-js-2.0"
#     publish: true # (Optional) Whether to publish the function. Default: true
#     code: "function handler(event) { ... }" # (Required) The source code of the function.
variable "functions" {
  description = "A map of CloudFront functions to be associated with the distribution. Each key in the map should be a unique identifier for the function, and the value should contain the configuration for that function."
  type        = any
  default     = {}
}