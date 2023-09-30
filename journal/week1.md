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
### Terraform Locals:

Locals allow us to define local variables
It will very useful when we want to transform dat from one format to another.

[Locals terraform](https://developer.hashicorp.com/terraform/language/values/locals)
```tf
locals  {
  s3_origin_id = "MyS3Origin"


}

```
### Terraform Data sources
This allow us to source data from cloud resources.
This is usefull when we want to reference cloud resources without importing them
[Terraform datsources] (https://developer.hashicorp.com/terraform/language/data-sources)
```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

```
## Working with JSON:
[jsonencode]
(https://developer.hashicorp.com/terraform/language/functions/jsonencode)
We use the jsonencode to inline the the policy in the HCL
eg:
```tf
 jsonencode({"hello"="world"})
{"hello":"world"}

```
### Changing the Lifecycle of the resources:

[Meta argument lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

### Terraform Data:
Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.
[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners
Provisioners allow you to execute commands on compute isntances eg:aws cli command
Not recommended by Hashicorp because tools like Ansible is better fit for this use case.
[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#provisioners-are-a-last-resort)
### Local-exec

This will execute a command on the machine running the terraform commands
eg: plan apply.
```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

```
(https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
### Remote-exec:
This will execute the command on the remote machine such as ssh to get into the machine
```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}

```
((https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec))