##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_distribution_status" {
  description = "The status of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.status
}

output "cloudfront_etag" {
  description = "The ETag of the CloudFront distribution. This is a unique identifier for the distribution's configuration and can be used for caching or versioning purposes."
  value       = aws_cloudfront_distribution.this.etag
}

output "cloudfront_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}