require 'sinatra'
require 'endpoint_base'

class HelloEndpoint < EndpointBase::Sinatra::Base
  post '/' do
    process_result 200
  end
end
