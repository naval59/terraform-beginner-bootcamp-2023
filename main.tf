terraform {
  required_providers {
  terratowns = { 
    source = "local.providers/local/terratowns"
	  version = "1.0.0"
	 }
	}

cloud {
  organization = "naval59"

  workspaces {
    name = "terra-house-1"
  }
 }
}


# resource "random_string" "bucket_name" {
#   lower            = true
#   upper            = false
#   length           = 32
#   special          = false

# }   
# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   user_uuid = var.user_uuid
#   bucket_name = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version = var.content_version
#   assets_path = var.assets_path
# }
provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_arcanum_hosting" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.arcanum.public_path
  content_version = var.arcanum.content_version

}

resource "terratowns_home" "home" {
  name = "Music everywhere!!!!!!"
  description = <<DESCRIPTION
melomaniac-mansion One with an abnormal fondness of music; a person who loves music.
DESCRIPTION
  domain_name = module.home_arcanum_hosting.domain_name
  town = "melomaniac-mansion"
  content_version = var.arcanum.content_version
}

module "home_kohli_hosting" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.kohli.public_path
  content_version = var.kohli.content_version

}

resource "terratowns_home" "Kohli" {
  name = "Kohli Famous Cricket Player"
  description = <<DESCRIPTION
Virat Kohli is Famous cricker from India.
He plays for India and RCB.
DESCRIPTION
  domain_name = module.home_kohli_hosting.domain_name
  town = "the-nomad-pad"
  content_version = var.kohli.content_version
}