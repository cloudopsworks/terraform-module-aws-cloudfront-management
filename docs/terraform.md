## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_continuous_deployment_policy.staging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy) | resource |
| [aws_cloudfront_distribution.staging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_origin_access_control.staging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.s3_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | n/a | `string` | `""` | no |
| <a name="input_default_ssl"></a> [default\_ssl](#input\_default\_ssl) | n/a | <pre>object({<br/>    enabled           = bool<br/>    cn                = string<br/>    san               = optional(list(string), [])<br/>    auto_validation   = optional(bool, false)<br/>    validation_method = optional(string, "DNS")<br/>    validation_domain = optional(string, "")<br/>    validation_email  = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "auto_validation": false,<br/>  "cn": "",<br/>  "enabled": false,<br/>  "san": [],<br/>  "validation_domain": "example.com",<br/>  "validation_email": "",<br/>  "validation_method": "DNS"<br/>}</pre> | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_functions"></a> [functions](#input\_functions) | A map of CloudFront functions to be associated with the distribution. Each key in the map should be a unique identifier for the function, and the value should contain the configuration for that function. | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the CloudFront distribution. If not provided, a name will be generated using the name\_prefix and system\_name. | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The prefix for the CloudFront distribution name. This is used to generate a name if the name variable is not provided. | `string` | `""` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | CloudFront distribution settings for the project. This variable should contain all the necessary configuration for the CloudFront distribution, such as origins, behaviors, and other settings. | `any` | `{}` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name of the CloudFront distribution. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The status of the CloudFront distribution. |
| <a name="output_cloudfront_etag"></a> [cloudfront\_etag](#output\_cloudfront\_etag) | The ETag of the CloudFront distribution. This is a unique identifier for the distribution's configuration and can be used for caching or versioning purposes. |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for the CloudFront distribution. |
