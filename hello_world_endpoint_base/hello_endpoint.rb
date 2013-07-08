require 'endpoint_base'
require 'multi_json'

class HelloEndpoint < EndpointBase
  post '/' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end
end