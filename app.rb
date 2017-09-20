require 'sinatra'
require 'sinatra/activerecord'
current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

get '/' do
  'Hello world!'
end

get '/pg_activity_stats' do
  count = PgStatActivity.count
  "There are #{count} things on the activities table."
end
