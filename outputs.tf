# output "bucket_name" {
#   description =  "bucket_name"
#   value       =  module.terrahouse_aws.bucket_name
# }

# output "s3_endpoint" {
#   description =  "s3 static website endpoint url"
#   value       =  module.terrahouse_aws.s3_website_endpoint
# }
# output "cloudfront_url" {
#   description =  "This is cloud front distribution domain name"
#   value       =  module.terrahouse_aws.cloudfront_url
# }
output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_arcanum_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.home_arcanum_hosting.s3_website_endpoint
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value = module.home_arcanum_hosting.domain_name
}