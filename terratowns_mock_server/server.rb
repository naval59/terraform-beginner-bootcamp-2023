require 'sinatra'
require 'json'
require 'pry'
require 'active_model'
#We will mock  having a state or database for this development server.
#by setting a global vraiable.You will never use a global variable in prod
$home = {}

# This is a ruby  class that includes validations from active records.
# This will represent our Home resources as a  ruby object.
class Home
  #ActiveModel is a part of Ruby on Rails
  #It is used as a ORM.It has a module within.
  #The production terratowns server is in rails and uses
  #Very similar and in most case identical validation
  #https://guides.rubyonrails.org/active_record_validations.html

  include ActiveModel::Validations
  #Create some virtual attributes to stored on this object
  # This will set a getter and setter
  #eg:
  #home = new Home()
  #home.town = 'hello' #setter
  #home.town()  #getter
  attr_accessor :town, :name, :description, :domain_name, :content_version
#gameres-groto

  validates :town, presence: true, inclusion: { in: [
    'cooker-cove',
    'melomaniac-mansion',
    'video-valley',
    'gamers-grotto',
    'the-nomad-pad'
  ] }
  #visibile to all users
  validates :name, presence: true
  #visibile to all users
  validates :description, presence: true
  #We want to lock down this to only from cloudfront
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 
#content version has to be integer
#We will have incremental
  validates :content_version, numericality: { only_integer: true }
end

#We are extending a class from Sinatra::Base to 
#turn this generic class to a sinatra web-framework
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end
#Return  hardcoded access token
  def x_access_code
    return '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    return 'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    auth_header = request.env["HTTP_AUTHORIZATION"]
    #Check if Auth header is present
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
# Does token match with one in DB
#If we can't find it  return error code
#Code = accesstoken = token
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
#Was there a user_uuid in the payload json
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
#Code and user_uid is matching for user
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings()
    find_user_by_bearer_token()
    #Puts will print to the terminal
    puts "# create - POST /api/homes"
#begin/rescue is a try/catch  if a error occur,result it 
    begin
	#Sinatra does not automatically parse json body as params
	#like rails we need to manually parse it
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Assign  the payload to variables
	#to make code more flexible
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]
#Prints var to console
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"
#Create a new home model and set to attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    #ensure validation checks pass
    unless home.valid?
      error 422, home.errors.messages.to_json
    end
#generating a uuid at random
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    #will mock our data to database
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
# will return uuid
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
	#does the uuid in the home matches with the mock db
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  #very similar to create action
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    #domain_name = payload["domain_name"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description
   # home.domain_name = domain_name
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
  end
end
#This what will run the server
TerraTownsMockServer.run!