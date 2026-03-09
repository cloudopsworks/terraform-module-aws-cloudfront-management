##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name" {
  description = "The name of the CloudFront distribution. If not provided, a name will be generated using the name_prefix and system_name."
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "The prefix for the CloudFront distribution name. This is used to generate a name if the name variable is not provided."
  type        = string
  default     = ""
}

variable "settings" {
  description = "CloudFront distribution settings for the project. This variable should contain all the necessary configuration for the CloudFront distribution, such as origins, behaviors, and other settings."
  type        = any
  default     = {}
}

variable "functions" {
  description = "A map of CloudFront functions to be associated with the distribution. Each key in the map should be a unique identifier for the function, and the value should contain the configuration for that function."
  type        = any
  default     = {}
}