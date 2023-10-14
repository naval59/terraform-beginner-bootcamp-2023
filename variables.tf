variable "terratowns_endpoint" {
 type = string
}

variable "terratowns_access_token" {
 type = string
}

variable "teacherseat_user_uuid" {
 type = string
}


# variable "content_version" {
#   type        = number
# }

variable "arcanum" {
  type        = object({
    public_path = string
    content_version = number
  })
}
variable "kohli" {
  type        = object({
    public_path = string
    content_version = number
  })
}