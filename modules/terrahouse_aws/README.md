## Terrahouse 

- index.html 
- error.html 
- assets
Above  are expected in public dir
```tf
module "home_arcanum" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.arcanum_public_path
  content_version = var.content_version

}
```
