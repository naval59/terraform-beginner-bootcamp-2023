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
variable "index_html_filepath" {
  description = "Local file path to the index.html file."
  type        = string

  validation {
    condition     = can(fileexists(var.index_html_filepath))
    error_message = "The specified index_html_filepath does not exist on your local filesystem."
  }
}
variable "error_html_filepath" {
  description = "Local file path to the error.html file."
  type        = string

  validation {
    condition     = can(fileexists(var.error_html_filepath))
    error_message = "The specified error_html_filepath does not exist on your local filesystem."
  }
}

variable "content_version" {
  description = "The version of the content (positive integer starting at 1)."
  type        = number

  validation {
    condition     = var.content_version >= 1 && can(regex("^[0-9]+$", tostring(var.content_version)))
    error_message = "content_version must be a positive integer starting at 1."
  }
}
variable "assets_path" {
  description = "Path to asset folder"
  type        = string
}

