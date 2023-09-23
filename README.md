# Terraform Beginner Bootcamp 2023

## Semmantic Versioning :mage:
This project use semmantic versioning for tagging

[semver.org](https://semver.org/)

The general formal eg: `1.0.1`
Given a version number **MAJOR.MINOR.PATCH**, increment the:

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


## Terraform Basics

## Terraform Registry
Terraform sources providers and modules in terraform registry
 This has the terraform Registry url:
 [Terraform Registry](https://registry.terraform.io/)

## ***Random Provider***
Providers are an interface to apis that will allow to craete resource
Below is the link for `Random provider` link
[Random_provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) 

### Terraform ***Modules***
Helps to make large amount of terraform code block to modular,portable ,sharable

## Terraform Console
Can see list of all the commands by typing ```terraform```

## Terraform init
At the begining of the terraform project we ll use ```terraform init```
This will download all the binaries from the providers which are required for the project

## Terraform plan
This will show the expected change in the infrastructure when terraform apply 
```terraform plan ```

#### Terraform apply
```terraform apply```
This will run the plan and execute it .Basically create sthe infra which has been defined in the terraform code.
We can auto approve sthe terraform apply by the command
```terraform apply --auto-approve```

### Terraform lock file
Contains the locked versioning for the providers
***file should not be *** in your commited VCS

## Terrafom state file
`.terraform.tfstate`
Contains the infornmation about the current state of the infra
file ***should not be commited *** to vcs
Critical file and contains sensitive data.Should store securely
`.tfstate.backup` it has the previous version of the state file 

### Terraform Directory
`.terraform` contains the binaries from the providers we atre using 


### Terraform Destroy
```terraform destroy ``` this will destroy the resource created .
eg: s3 bucket craeted will be destroyed

## Issues with Terraform cloud login and gitpod
when we try to login terraform cloud  it throws error related invalid token

## Workaround 
Manually add the token and create file manually to fix it 
```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
```
update token value in below file with token value :
```json
{
    "credentials": {
      "app.terraform.io": {
        "token": "sdghjshdjhjah"
      }
    }
  }
```
## Automate the workaround
Set up a bash script to generate tfrc json file
Store terraform cred in gp env and env variable

## Setup Alias for terraform command

Write a bash script toi setup alias for ```terraform command```
````sh
#!/usr/bin/env bash

# Define the desired alias and the command it should run
desired_alias="tf"
command_to_alias="terraform"

# Define the path to the ~/.bash_profile file
bash_profile="$HOME/.bash_profile"

# Check if the alias already exists in ~/.bash_profile
if grep -q "alias $desired_alias='$command_to_alias'" "$bash_profile"; then
  echo "Alias '$desired_alias' already exists in $bash_profile."
else
  # If the alias doesn't exist, add it to ~/.bash_profile
  echo "alias $desired_alias='$command_to_alias'" >> "$bash_profile"
  source "$bash_profile"  # Apply the changes in the current session
  echo "Alias '$desired_alias' set for '$command_to_alias' in $bash_profile."
fi 

```
Can test aftetr opening a new git pod and try `tf`