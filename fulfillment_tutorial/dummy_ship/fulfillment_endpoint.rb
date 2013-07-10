require 'endpoint_base'
require 'multi_json'

class FulfillmentEndpoint < EndpointBase
  post '/drop_ship' do
    process_result 200, { 'message_id' => @message[:message_id] }
  end

  post '/validate_address' do
    address = @message[:payload]['order']['shipping_address']

    begin
      result = DummyShip.validate_address(address)
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:info",
        "payload" => { "result" => "The address is valid, and the shipment will be sent." } }
    rescue Exception => e
      process_result 200, { 'message_id' => @message[:message_id], 'message' => "notification:error",
        "payload" => { "result" => "There was a problem with this address." } }
    end
  end
end