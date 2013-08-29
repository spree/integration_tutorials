require 'endpoint_base'

class FulfillmentEndpoint < EndpointBase
  post '/drop_ship' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end
end