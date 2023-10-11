# Terraform Beginner Bootcamp 2023 -Week 2

## Working with Ruby

### Bundler

Bundler is a package manager in Ruby.
Its primary way to install ruby packages(Called `gems`).

#### Install Gems
 You need to create Gemfile and define  your gems in the file.

 ```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
 ```
Then you need to run the `bundle install` command

This will install the gems on the system globally.(Unlike nodejs which install packages in place in a folder called node_modules)
A Gemfile.lock will be created to lock down the version of gems in this project .

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed 

### Sinatra
Sinatra is a micro web framework for ruby to build web-apps.

Its great for simple project or dev or webservers.

(https://sinatrarb.com/)

## Terratowns Mock Server.

### Running the webserver
We can run the webserver by running the following commands.
```rb
bundle install
bundle exec ruby server.rb 

```
All the code is store in the file `server.rb`
