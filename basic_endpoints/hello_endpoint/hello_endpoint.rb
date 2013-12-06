require 'sinatra'
require 'sinatra/json'
require 'json'
require 'multi_json'

post '/' do
  message = JSON.parse(request.body.read)
  json 'message_id' => message['message_id']
end