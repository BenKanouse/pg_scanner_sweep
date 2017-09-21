require 'sinatra'
require 'sinatra/activerecord'
require 'json'

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

before do
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "GET"
end

get '/' do
  'Hello world!'
end

get '/pg_activity_stats' do
  content_type :json
  PgStatActivity.all.to_json
end
