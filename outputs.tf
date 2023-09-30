output "bucket_name" {
  description =  "bucket_name"
  value       =  module.terrahouse_aws.bucket_name
}

output "s3_endpoint" {
  description =  "s3 static website endpoint url"
  value       =  module.terrahouse_aws.s3_website_endpoint
}
