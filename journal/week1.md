# Terraform Beginner Bootcamp 2023 -Week 1

## Root Module structure
Root module structure is as follows:

- PROJECT_ROOT

  - [ ] main.tf        -- everything else
  - [ ] variables.tf  -- stores input variables
  - [ ] outputs.tf    --  stores our output
  - [ ] providers.tf   -- Defined required providers and their configurations
  - [ ] terraform.tfvars -- the data of variables we want to store for  terraform project 
  - [ ] README.md         -- all the informations regarding the module 
[Root Module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Input variables
### Terraform Cloud variables

In terraform we can set two kind of variables:

- Environment variables : The one you set in bash terminal eg:aws credentials
- Terraform variables: The one you set in terraform tfvars file

We can set terraform cloud variables as sensitive so that its no visible in UI as such

### Loading Terraform Input variables

### var flag
We can us `-var` or `-var-file` to set as input variable or override variables in tfvars file eg: `terraform -var user_uuid="my-user_id"`

### var-file flag

Assume we have multiple environments and values for the var changes from enviornment to environment .So we manage different files 
eg: ```terraform plan -var-file=prod.tfvars```
eg: ```terraform plan -var-file=uat.tfvars```

### terraform.tfvars

This is the default file to load terraform variables

### auto.tfvars
Terraform also automatically loads a number of variable definitions files if they are present:

Files named exactly terraform.tfvars or terraform.tfvars.json.
- Any files with names ending in .auto.tfvars or .auto.tfvars.json.
- Files whose names end with .json are parsed instead as JSON objects, with the root object properties corresponding to variable names



[Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)

## Dealing with configuration drift

## What happen if we lose our state file?
If we lose terraform state file .We need to manually delete all the instances.
We can use ```terraform import``` but you need to refer the documents of providers 

### Fix missing resources with Terraform import
```terraform import aws_s3_bucket.bucket bucket-name```
 [Terraform Import] (https://developer.hashicorp.com/terraform/cli/import#import)

### Fix manual configuration

If we manually delete instance or configs by mistake.
Running```terraform plan``` will check terraform state file and put the missing or broken part back.

## Terraform modules
### Terraform module structure:
Its recomended to keep the modules in ```modules```  directory.


### Passing input variables:
We can pass input variables to modules .
Module has to define/declare the variables in variables.tf file 
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```
### Module sources
[Module sources](https://developer.hashicorp.com/terraform/language/modules/sources)

Using the sources we can import the module from various places like
- Github
- Hashicorp 
- Terraform Registry
- Locally
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"

}
```
## Consideration when using chatgpt
LLMs like chatgpt  does not been trained for terraform docs or code with the latest code.
example could be deprecated.

## Working with files in terraform
### File exist function
This is a builtin function to check if a file exist .
eg:
```tf
 condition     = can(fileexists(var.error_html_filepath))
 ```
(https://developer.hashicorp.com/terraform/language/functions/fileexists)
### Filemd5
(https://developer.hashicorp.com/terraform/language/functions/md5)
### Path Variable
In terraform there is a special var called ```path``` .Allows us to reference local variable 
- path.module : get the path for the current module
- path.root : get the root module

[Special path variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

eg:
```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag = filemd5(var.index_html_filepath)
}
```

