variable "user_uuid" {
  description = "The UUID of the user."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "user_uuid must be in the UUID format (e.g., 123e4567-e89b-12d3-a456-426614174000)"
  }
}

variable "bucket_name" {
  description = "The name of the AWS S3 bucket."

  # Specify the type as string.
  type        = string

  validation {
    # Use a regular expression to validate the bucket name.
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "The bucket name must be between 3 and 63 characters long and can only contain lowercase letters, numbers, hyphens, and periods."
  }
}